<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%		
	String sServerUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort();
	
	if(sServerUrl.indexOf("localhost") == -1 && sServerUrl.indexOf("itsone.iptime.org") == -1) {
		sServerUrl = "https://www.seowongolf.co.kr";
	}
	
	String sContextPath = sServerUrl + request.getContextPath();
%>
<jsp:include page="../include/header.jsp" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/m_hills/content.css?v=2'/>">

<script src="https://developers.kakao.com/sdk/js/kakao.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/hellojs/2.0.0-4/hello.all.js"></script>
<%-- <script type="text/javascript" src="<c:url value='/js/jquery-1.11.3.js'/>"></script> --%>
<script type="text/javascript" src="<c:url value='/js/m_naverLogin_implicit-1.0.3.js'/>" charset="utf-8"></script>
<script type="text/javascript">

	/* var kakao_key = "2fdf4e8e6e6d474282353f5ef06c8c59";
	var kakao_rest_key = "ef9ec1fe180c5b0eee96785f8dd0c2f3"; */

	var kakao_key = "dc1b9e390d561baaca39c286b7f41b23";
	var kakao_rest_key = "26f49a2ab16997c6024b55d9eb19a10c";
	
	var kakao_client_secret = "NONRlbLaUI5ykYcO0oIUJKvIm2E8GMPi";
	var kakao_oauth_url = "<%= sContextPath %>/m_hills/member/oauth.do";
	var kakao_button_image = "<c:url value='/images/m_hills/login_kakao.png'/>";
	
	var naver_domain = "<%= sServerUrl %>";
	var naver_key = "wSzJ1pJXrPElFz9xdZF2";
	var naver_callback = "<%= sContextPath %>/m_hills/member/succNaverLogin.do";
	var naver_button_image = "<c:url value='/images/m_hills/login_naver.png'/>";
	
	var facebook_key = "564458247381194";
	var facebook_version = "v3.2";
	var facebook_button_image = "<c:url value='/images/m_hills/login_face.png'/>";
	
	$(document).ready(function() { 
		onLoadPage(); 
	});

	function onLoadPage() {			
		if("${sessionScope.appUser}" != 'Y') {
			facebookInit();
			
			googleInit();			
		}
		
		kakaoInit();
		
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId != "") {
			location.href = "<c:url value='/m_hills/index.do'/>";	
		}
		
		var id = getCookie("id");
		var pw = getCookie("pw");
		
		if(id != null && id != "") {
			$("#msId").val(id);
			$("#chkSaveId").attr('checked', true);
		}

		$("#msId").keypress(function (event) {
	        if(event.keyCode == 13) {
	        	actionLogin();
	        }
	    });

		$("#msPw").keypress(function (event) {
	        if(event.keyCode == 13) {
	        	actionLogin();
	        }
	    });
	}

	function actionLogin() {
		var sUrl = "<c:url value='/hills/member/actionLogin.do'/>";
		var sParams = {};
		
		var msId = $("#msId").val();
		var msPw = $("#msPw").val();
		var autoLogin = $('input:checkbox[id="chkAutoLogin"]').is(":checked") ? "1" : "0";
		
		if(msId == "") {
			alert("???????????? ???????????????.");
			return;
		} else {
			sParams["msId"] = msId;
		}
		
		if(msPw == "") {
			alert("??????????????? ???????????????.");
			return;
		} else {
			sParams["msPw"] = msPw;
		}
		
		sParams["autoLogin"] = autoLogin;
		
		progressStart();
		
        mAjax2(sUrl, sParams, function(data) {
        	progressStop();
        	
        	if(data.resultCode == "0000") {
        		if($('input:checkbox[id="chkSaveId"]').is(":checked")){
        			setCookie("id", $("#msId").val(), 365);
        		} else {
        			setCookie("id", "", 365);
        		}
    			
        		var msNum = data.rows.msNum;
        		
        		if(msNum != null && msNum != "") {
            		location.href = "<c:url value='/m_hills/index.do?msNum=" + msNum + "'/>";
            		return;
        		}
    			
        		location.href = "<c:url value='/m_hills/index.do'/>";
            } else if(data.resultCode == "1000") {
        		if($('input:checkbox[id="chkSaveId"]').is(":checked")){
        			setCookie("id", $("#msId").val(), 365);
        		} else {
        			setCookie("id", "", 365);
        		}

            	alert(data.resultMessage);
    			
        		var msNum = data.rows.msNum;
        		
        		if(msNum != null && msNum != "") {
            		location.href = "<c:url value='/m_hills/member/member.do?msNum=" + msNum + "'/>";
            		return;
        		}
        		
        		location.href = "<c:url value='/m_hills/member/member.do'/>";
            } else if(data.resultCode == "2000") {
        		if($('input:checkbox[id="chkSaveId"]').is(":checked")){
        			setCookie("id", $("#msId").val(), 365);
        		} else {
        			setCookie("id", "", 365);
        		}

            	alert(data.resultMessage);
    			
        		var msNum = data.rows.msNum;
        		
        		if(msNum != null && msNum != "") {
            		location.href = "<c:url value='/m_hills/member/member.do?msNum=" + msNum + "'/>";
            		return;
        		}
        		
        		location.href = "<c:url value='/m_hills/member/member.do'/>";
            } else if(data.resultCode == "3000") {
        		if($('input:checkbox[id="chkSaveId"]').is(":checked")){
        			setCookie("id", $("#msId").val(), 365);
        		} else {
        			setCookie("id", "", 365);
        		}

            	alert(data.resultMessage);
    			
        		var msNum = data.rows.msNum;
        		
        		if(msNum != null && msNum != "") {
            		location.href = "<c:url value='/m_hills/member/agree.do?msNum=" + msNum + "'/>";
            		return;
        		}
        		
        		location.href = "<c:url value='/m_hills/member/agree.do'/>";
            } else {
            	alert(data.resultMessage);
            }
        });
	}
	
	function googleInit() {
		hello.init({
			google: '447621951123-uvka3s8cq479k9tvi427mlk3genhs7tt.apps.googleusercontent.com'
		}, {redirect_uri: '<%= sContextPath %>/m_hills/member/login.do'});
	}
	
	function authGoogle(){
		hello('google').login({scope: 'email'}).then(function(auth) {
			hello(auth.network).api('/me').then(function(r) {
				accessToken = auth.authResponse.access_token;
				getGoogleMe(); 
			});
		});
	}

	function getGoogleMe(){
		hello('google').api('me').then(
			function(json) {
				succLoginWithGoogle(json.id, json.name, json.gender == "male" ? "1" : "2");
			}, 
			function(e) {
	    		console.log('me error : ' + e.error.message);
			}
		);
	}
	
	function kakaoInit() {
		$("#kakao_login_button").attr("src", kakao_button_image);	
		
		Kakao.init(kakao_key);		
	}
	
	function facebookInit() {
		$("#facebook_login_button").attr("src", facebook_button_image);		
		
		document.getElementById('facebook_login_button').addEventListener('click', function() {
		    //do the login
		    FB.login(checkLoginState, {scope: 'email,public_profile', return_scopes: true});
		}, false);
		
		window.fbAsyncInit = function() {
			FB.init({
				appId      : facebook_key,
				cookie     : true,
				xfbml      : true,
				version    : facebook_version
			});
			    
			FB.AppEvents.logPageView();   		    
		};
	
		(function(d, s, id){
			var js, fjs = d.getElementsByTagName(s)[0];
			if (d.getElementById(id)) {return;}
			js = d.createElement(s); js.id = id;
			js.src = "https://connect.facebook.net/en_US/sdk.js";
			fjs.parentNode.insertBefore(js, fjs);
		}(document, 'script', 'facebook-jssdk'));		
	}
	
	function loginWithKakao() {
		// RestAPI
		var sUrl = String.format("https://kauth.kakao.com/oauth/authorize?client_id={0}&redirect_uri={1}&response_type=code", kakao_rest_key, kakao_oauth_url);

		//var sUrl = String.format("https://kauth.kakao.com/oauth/authorize?client_id={0}&client_secret={1}&redirect_uri={2}&response_type=code", kakao_rest_key, kakao_client_secret, kakao_oauth_url);
		
		location.href = sUrl;
		
	  // ????????? ?????? ????????????.
	  /* Kakao.Auth.login({
	    success: function(authObj) {
	    	Kakao.API.request({
	            url: '/v1/user/me',
	            success: function(res) {
	            	succLoginWithKakao(res.id, res.properties.nickname, "");
	        },
	        fail: function(error) {
	          alert(JSON.stringify(error));
	        }
	      });
	    },
	    fail: function(err) {
	      alert(JSON.stringify(err));
	    }
	  }); */
	}
	
	function checkLoginState() {
		FB.getLoginStatus(function(response) {
			if (response.status === 'connected') {
				FB.api('/me', function(response) {
					succLoginWithFacebook(response.id, response.name, "");
				});
			}
		});		
	}
	
	function succLoginWithGoogle(id, name, gender) {
		gender = "";
		actionLoginForSocial("GOOGLE", id, name, gender);
	}
	
	function succLoginWithNaver(id, name, gender) {
		if(gender == "M") {
			gender = "1";
		} else if(gender == "F") {
			gender = "2";
		} else {
			gender = "";
		}
		actionLoginForSocial("NAVER", id, name, gender);
	}
	
	function succLoginWithKakao(id, name, gender) {
		actionLoginForSocial("KAKAO", id, name, gender);
	}
	
	function succLoginWithFacebook(id, name, gender) {
		actionLoginForSocial("FACEBOOK", id, name, gender);
	}
	
	function actionLoginForSocial(type, id, name, gender) {
		var sUrl = "<c:url value='/hills/member/signUpForSocial.do'/>";
		var sParams = "";
		
		if (type != "") {
			sParams += String.format("msLoginCd={0}", type);
		} else {
			alert("??? ??? ?????? ???????????????. ?????? ??????????????????.");
		}
		
		if (id != "") {
			sParams += String.format("&msId={0}", id);
		} else {
			alert("??? ??? ?????? ???????????????. ?????? ??????????????????.");
		}
		
		if (name != "") {
			sParams += String.format("&msName={0}", name);
		} else {
			alert("??? ??? ?????? ???????????????. ?????? ??????????????????.");
		}
		
		if (gender != "") {
			sParams += String.format("&msSex={0}", gender);
		}
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			progressStop();
			
			if(data.resultCode == "0000") {
				location.href = "<c:url value='/m_hills/index.do'/>";
			} else if(data.resultCode == "1000") {
				var msNum = data.rows.msNum;
				var msName = data.rows.msName;
				var msId = data.rows.msId
				var msLoginCd = data.rows.msLoginCd
				
				location.href = "<c:url value='/m_hills/member/join05.do'/>?msNum=" + msNum + "&msName=" + msName + "&msId=" + msId + "&msLoginCd=" + msLoginCd;
			} else {
				alert(data.resultMessage);
			}
		});
	}	
</script>

<div id="wrap">	
	<div class="mainTitle">
		<img src="<c:url value='/images/m_hills/titleDot.png'/>" alt=""> Login <img src="<c:url value='/images/m_hills/titleDot.png'/>" alt="">
	</div>

	<div class="contents">
		<div class="grayBg">
			<div class="loginCont">
				 <p class="loginTitle">????????? ????????? ??? ?????? ????????? ???????????????~!</p>
				 <div class="logInputBox">
					<div class="loginInput">
					  <input type="text" value="" placeholder="?????????&?????????????????? ????????? ???????????????." id="msId">
					  <input type="password" maxlength="20" placeholder="????????????" id="msPw">
					</div>
					 <div class="loginBtn"><a href="javascript:actionLogin()">?????????</a></div>
				 </div>

				 <div class="memBox">
					 <span><input type="checkbox" name="checkbox" id="chkSaveId">
					 &nbsp;??????????????? </span>
					 <span><input type="checkbox" name="checkbox" id="chkAutoLogin">
					 &nbsp;??????????????? </span>
				 </div>	
				 <div class="LogFindBtn">
					<a href="<c:url value='/m_hills/member/find.do'/>" class="id_Btn">???????????????</a>
					<a href="<c:url value='/m_hills/member/find.do'/>">??????????????????</a>
				 </div>
				 <p class="loginTitle">SNS???????????? ???????????? ??? ???????????? ???????????????.</p>

					 <c:if test="${sessionScope.appUser != 'Y'}">
					 <div class="snsJoinBox">
					 	<ul>
						 	<li><div id="naver_id_login" style="display:inline-block;"></div></li>
						 	<script type="text/javascript">
								var naver_id_login = new naver_id_login(naver_key, naver_callback);
								var state = naver_id_login.getUniqState();
								naver_id_login.setButton("", 10, "", naver_button_image);//????????? ????????? ????????? 
								naver_id_login.setDomain(naver_domain);
								naver_id_login.setState(state);
								naver_id_login.setPopup();
								naver_id_login.init_naver_id_login();
							</script>
							<li><a id="custom-login-btn" href="javascript:loginWithKakao()"><img id="kakao_login_button"/></a></li>
							<li><img id="facebook_login_button" width="110px"/></li>
							<li><img src="<c:url value='/images/m_hills/login_google.png'/>" alt="" onclick="authGoogle()"></li>
						</ul>
					 </div>
					 
					 </c:if>
					 <c:if test="${sessionScope.appUser == 'Y'}">
					 <div class="snsJoinBox1">
					 	<ul>
						 	<li><div id="naver_id_login" style="display:inline-block;"></div></li>
						 	<script type="text/javascript">
								var naver_id_login = new naver_id_login(naver_key, naver_callback);
								var state = naver_id_login.getUniqState();
								naver_id_login.setButton("", 10, "", naver_button_image);//????????? ????????? ????????? 
								naver_id_login.setDomain(naver_domain);
								naver_id_login.setState(state);
								naver_id_login.setPopup();
								naver_id_login.init_naver_id_login();
							</script>
							<li><a id="custom-login-btn" href="javascript:loginWithKakao()"><img id="kakao_login_button"/></a></li>
						</ul>
					 </div>
					 </c:if>
				 	
			</div>
			
			<div class="etcWrap">
					<p><img src="<c:url value='/images/m_hills/text_etc.png'/>" alt=""></p>
					<div class="etcBnBox">
						<ul>
							<li>
								<a href="<c:url value='/m_hills/board/view.do?bbsType=51&idx=94'/>"><img src="<c:url value='/images/m_hills/bn_etc1.jpg'/>" alt=""></a>
								<h3>??????????????????</h3>
							</li>
							<li>
								<a href="<c:url value='/m_hills/board/view.do?bbsType=51&idx=83'/>"><img src="<c:url value='/images/m_hills/bn_etc2.jpg'/>" alt=""></a>
								<h3>??????????????????</h3>
							</li>
							<li>
								<a href="<c:url value='/m_hills/board/view.do?bbsType=53&idx=84'/>"><img src="<c:url value='/images/m_hills/bn_etc3.jpg'/>" alt=""></a>
								<h3>????????????</h3>
							</li>
							<li>
								<a href="<c:url value='/m_hills/board/view.do?bbsType=54&idx=82'/>"><img src="<c:url value='/images/m_hills/bn_etc4.jpg'/>" alt=""></a>
								<h3>??????<br>???????????????</h3>
							</li>							
						</ul>
					</div>
					<h2><a href="<c:url value='/m_hills/board/list.do?bbsType=51'/>"><img src="<c:url value='/images/m_hills/btn_etcM.png'/>" alt=""></a></h2>
					<div class="etcCover">
						<p>????????????<br>
						??????????????????.</p>
					</div>
				</div>

		</div>
	</div><!-- contents End -->
   
<jsp:include page="../include/footer.jsp" flush="true" />
</div>   

</body>
</html>