<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../include/header.jsp" />
<jsp:include page="../include/subTop.jsp" />
<script type="text/javascript">

	$(document).ready(function() { 
		var content = "${content}";
		
		content = convertSpecialCharacters(content);
		
		$("#txtContent").append(content);
		
		//initImage();
		
		initAttachFiles();	
		
		//doSearchReply();
	});
	
	function initImage() {
		var imageName = "<c:out value='${upFileName1}'/>";
		var folderName = "<c:out value='${folderName}'/>";
		
		if(imageName != "") {
			$("#viewMainImage").attr("src", "<c:url value='/common/downloadImage.do?division=hills&folderName=" + folderName + "&fileName=" + imageName + "'/>");
		} else {
			$("#viewMainImage").attr("src", "<c:url value='/images/hills/boardDefaultImage.jpg'/>");
		}
	}
	
	function initAttachFiles() {
		var file1 = "<c:out value='${upOriginFile2}'/>";
		var file2 = "<c:out value='${upOriginFile3}'/>";
		var originFileName1 = "<c:out value='${upFileName2}'/>";
		var originFileName2 = "<c:out value='${upFileName3}'/>";
		var folderName = "<c:out value='${folderName}'/>";
	
		if(file2 != "") {
			$("#viewAttach").show();
		}
		
		if(file1 != "") {
			var extension = getExtensionOfFilename(file1);
			
			if(extension == "jpg" || extension == "jpeg" || extension == "png") {
				$("#viewMainImage").attr("src", "<c:url value='/common/downloadImage.do?division=hills&folderName=" + folderName + "&fileName=" + originFileName1 + "'/>");
			} else {
				$("#attachFile1 a").append(file1);
				$("#attachFile1 a").click(function() {
					downloadAttachFile(folderName, file1, originFileName1);
				});
			}
		}
		
		if(file2 != "") {
			$("#attachFile2 a").append(file2);
			$("#attachFile2 a").click(function() {
				downloadAttachFile(folderName, file2, originFileName2);
			});
		}
	}
	
	function downloadAttachFile(folderName, fileName, originFileName) {
		var sUrl = "<c:url value='/common/downloadFile.do'/>";
		var sParams = "";
		
		sParams += String.format("?fileName={0}", fileName);
		sParams += String.format("&originFileName={0}", originFileName);
		sParams += String.format("&folderName={0}", folderName);
		sParams += String.format("&division={0}", "hills");
	
		window.open(sUrl + sParams);
	}
	
	function doDelete() {
		var sUrl = "<c:url value='/hills/board/deleteBoard.do'/>";
		var sParams = "";
		
		var idx = "<c:out value='${idx}'/>";
		sParams += String.format("&idx={0}", idx);
		
		var deleteYn = confirm("?????? ?????????????????????????");
		
		if(deleteYn) {
			mAjax(sUrl, sParams, function(data) {
	        	if(data.resultCode == "0000") {
	         		alert("?????? ?????????????????????.");
	         	   
	         		location.href = "<c:url value='/hills/board/list.do?bbsType=${bbsType}'/>"
	            } else {
	         	   alert(data.resultMessage);
	            }
	        });	
		}
	}
	
	function doDeleteReply(reIdx) {
		var sUrl = "<c:url value='/hills/board/deleteReply.do'/>";
		var sParams = "";
		
		var idx = "<c:out value='${idx}'/>";
		sParams += String.format("&idx={0}", idx);
		sParams += String.format("&replyIdx={0}", reIdx);
		
		var deleteYn = confirm("????????? ?????????????????????????");
		
		if(deleteYn) {
			mAjax(sUrl, sParams, function(data) {
	        	if(data.resultCode == "0000") {
	        		doSearchReply();
	            } else {
	         	   alert(data.resultMessage);
	            }
	        });	
		}
	}
	
	function writeReply() {
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId == "") {
			alert("????????? ??? ?????? ???????????????.");
			return;
		}
		
		var sUrl = "<c:url value='/hills/board/writeReply.do'/>";
		
		var reply = $("#txtReply").val();
		
		if(reply == null || reply == "") {
			alert("????????? ???????????????.");
			return;
		}
		
		var formData = new FormData($("#replyForm")[0]);
		
		progressStart();
		
		mPostAjax(sUrl, formData, function(data) {
     		progressStop();
     		
        	if(data.resultCode == "0000") {
        		$("#txtReply").val("");
        		
         		alert("?????? ???????????????.");
         		         		
         		doSearchReply();
            } else {
         	   alert(data.resultMessage);
            }
        });	
	}
	
	function doSearchReply() {
		var reBody = $("#commentContainer");
		
		var sUrl = "<c:url value='/hills/board/getBoardReplyData.do'/>";
		var sParams = "";
		
		sParams += String.format("idx={0}", "${idx}");
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			if(data.resultCode == "0000") {
				reBody.empty();
				
				var rows = data.rows;
				
				$("#txtReplyCnt").html(rows.length);
				
				for(i=0; i<rows.length; i++) {
					var reply = "";
					reply += "<div class='replyBox'>                                                                                             ";
	         		reply += "    <img src='<c:url value='/images/hills/rp_arrow.png'/>' alt='' class='img'>									 ";
	         		reply += "    <div class='reply'>                                                        									 ";
	         		reply += "        <span class='new'><img src='<c:url value='/images/hills/rp_new.png'/>' alt='' style='display:{0}'></span> ";
	         		reply += "        <span class='name'>{1}</span>                                         									 ";
	        		reply += "        <span class='replyCont'>{2}</span>                                     									 ";
	         		reply += "        <span class='date'>{3}</span>                                           									 ";
	        		reply += "        <a href='javascript:doDeleteReply({4})' class='delete' style='display:{5};'>??????</a>    					 ";
	         		reply += "    </div>                                                                     									 ";
	         		reply += "</div>                                                                         									 ";
	         		
	         		var regDate = rows[i].REGDATE;
	         		var curDate = new Date().yyyymmdd();
	         		var name = rows[i].USERNAME;
	         		var content = rows[i].CONTENT;
	         		var replyIdx = rows[i].REPLY_IDX;
	         		var userNum = rows[i].USERNUM;
	         		var newDisplay = regDate == curDate ? "inline" : "none";
	         		var delDisplay = userNum == "${sessionScope.msMember.msNum}" ? "inline" : "none";
	         		regDate = regDate.substring(0, 4) + "/" + regDate.substring(4, 6) + "/" + regDate.substring(6, 8);
	         		
	         		reply = String.format(reply, newDisplay, name, content, regDate, replyIdx, delDisplay);
	         		
	         		reBody.append(reply);
				}
			} else {
				alert(data.resultMessage);	
			}
			
			progressStop();
		});
	}
	
	function doConsultation() {
		var sUrl = "<c:url value='/hills/board/doConsultation.do'/>";
		var sParams = "";
		
		var agree = $(":input:checkbox[name=chkAgree]:checked").val();
		if(agree == null) {
			alert("????????? ???????????????.");
			return;
		}
		
		var name, phone, interest;
		name = $("#txtName").val();
		phone = $("#txtPhone1").val() + $("#txtPhone2").val() + $("#txtPhone3").val();
		interest = $("#txtInterest").val();

		if(name == "") {
			alert("????????? ???????????????.");
			return;
		}
		if(phone == "") {
			alert("?????????????????? ???????????????.");
			return;
		}
		if(interest == "") {
			alert("??????????????? ???????????????.");
			return;
		}

		sParams += String.format("coDiv={0}", "65");
		sParams += String.format("&name={0}", name);
		sParams += String.format("&phone={0}", phone);
		sParams += String.format("&interest={0}", interest);
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			if(data.resultCode == "0000") {
				alert("???????????? ?????????????????????.");
			} else {
				alert(data.resultMessage);	
			}
			
			progressStop();
		});		
	}
</script>

<div class="lnbBox">
	<div class="lnb">
		<img src="<c:url value='/images/hills/ico-home.png'/>" alt="">
		<c:if test="${bbsType eq '51'}">
			<p>???????????? &nbsp;&nbsp;&nbsp; ??? <span>????????????</span></p>
		</c:if>
		<c:if test="${bbsType eq '52'}">
			<p>???????????? &nbsp;&nbsp;&nbsp; ??? <span>????????????(??????)</span></p>
		</c:if>
		<c:if test="${bbsType eq '53'}">
			<p>???????????? &nbsp;&nbsp;&nbsp; ??? <span>??????/??????/??????</span></p>
		</c:if>
		<c:if test="${bbsType eq '54'}">
			<p>???????????? &nbsp;&nbsp;&nbsp; ??? <span>??????</span></p>
		</c:if>
	</div>
</div>

<div id="wrap">
	<div class="contents">
		<div class="myzoneTabList5">
			<a href="<c:url value='/hills/board/jhqna.do'/>" class="">????????????</a>
			<c:if test="${bbsType eq '51'}">
				<a href="<c:url value='/hills/board/list.do?bbsType=51'/>" class="on">????????????</a>
			</c:if>
			<c:if test="${bbsType ne '51'}">
				<a href="<c:url value='/hills/board/list.do?bbsType=51'/>">????????????</a>
			</c:if>
			<c:if test="${bbsType eq '52'}">
			<a href="<c:url value='/hills/board/list.do?bbsType=52'/>" class="on">????????????(??????)</a>
			</c:if>
			<c:if test="${bbsType ne '52'}">
			<a href="<c:url value='/hills/board/list.do?bbsType=52'/>">????????????(??????)</a>
			</c:if>
			<c:if test="${bbsType eq '53'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=53'/>" class="on">??????/??????/??????</a>
			</c:if>
			<c:if test="${bbsType ne '53'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=53'/>">??????/??????/??????</a>
			</c:if>				
			<c:if test="${bbsType eq '54'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=54'/>" class="on">??????</a>
			</c:if>
			<c:if test="${bbsType ne '54'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=54'/>">??????</a>
			</c:if>			
		</div>
		<div class="subTitle subBottom">
			<c:if test="${bbsType eq '51'}">
				<span class="title">????????????</span>
			</c:if>
			<c:if test="${bbsType eq '52'}">
				<span class="title">????????????(??????)</span>
			</c:if>
			<c:if test="${bbsType eq '53'}">
				<span class="title">??????/??????/??????</span>
			</c:if>
			<c:if test="${bbsType eq '54'}">
				<span class="title">??????</span>
			</c:if>
		</div>
		
		<div class="viewBox grayBgBox">
			<div class="viewTitleBox">
				<span class="viewTitle">${title}</span>
				<span class="viewDate">${regDate}</span>
			</div>		
			<c:choose>
		       	<c:when test="${idx eq '94'}">
		       		<img src="" id="viewMainImage" class="viewMainImage"  alt="">

					<div class="wjBottom">		
						<div class="bottomInfo">
							<img src="<c:url value='/images/hills/w_logo.jpg'/>" alt="" class="w_logo">
				
							<div class="wjInputBox">
								<div class="floatInput">
									<ul class="infoBox">
										<li class="title">??????</li>
										<li><input type="text" id="txtName" name="MemName" maxlength="10" class="txtInput"></li>
									</ul>
									<ul class="infoBox">
										<li class="title">?????????</li>
										<li><input type="text" class="phoneInput" maxlength="3" id="txtPhone1"> - <input type="text" class="phoneInput" maxlength="4" id="txtPhone2"> - <input type="text" class="phoneInput" maxlength="4" id="txtPhone3"></li>
									</ul>
								</div>
								<div class="floatInput">
									<ul class="infoBox">
										<li class="title">????????????</li>
										<li><input type="text" name="MemName" maxlength="10" class="txtInput" id="txtInterest"></li>
									</ul>
									<p class="agreeyCheck"> 
										<input type="checkbox" class="agCheck" name="chkAgree"> ???????????? ?????? ??? ????????? ???????????????.<br> <a href="/hills/board/wj.do">[???????????????]</a> 
									</p>
								</div>
							</div>
				
							<ul class="wjNumberBox">
								<li class="link"><a href="javascript:doConsultation();" class="linkBtn">????????????</a></li>
								<li class="number">010.5764.3301</li>
								<li class="text">?????? ????????? ?????? ?????????<br> ?????? ???????????? ???????????????.</li> 
							</ul>
						</div>
					</div>
		       	</c:when>
		       	
		       	<c:when test="${idx eq '84'}">
		       		<img src="" id="viewMainImage" class="viewMainImage"  alt="" usemap="#Map" border="0">
		       		<map name="Map" id="Map">
  						<area shape="rect" coords="312,4623,787,4705" href="https://b2b.onemount.co.kr/seowon.php" target="_blank" />
					</map>
		       	</c:when>
		       	
		       	<c:otherwise>
				<img src="" id="viewMainImage" class="viewMainImage"  alt="">
		       	</c:otherwise>
		   	</c:choose>
			<div class="viewTxt" id="txtContent">
			</div>
			<div id="viewAttach" style="display: none">
				 <img class="attachImg" src="<c:url value='/images/hills/board_file.png'/>"/>
				 <span>???????????? : </span>
				 <span id="attachFile1"><a></a></span>
				 <span id="attachFile2"><a></a></span>	 
			</div>
		</div> 
		<div class="btnBox">  
			<a href="<c:url value='/hills/board/list.do?bbsType=${bbsType}'/>" class="grayBtn">??????</a>
			<c:if test="${sessionScope.msMember.webAdmin == 'Y'}">
				<a href="<c:url value='/hills/board/modify.do?bbsType=${bbsType}&idx=${idx}'/>" class="orangeBtn">??????</a>
				<a href="javascript:doDelete()" class="grayBtn">??????</a>
			</c:if>
		</div>
		
	</div><!-- contents End -->
</div>

<jsp:include page="../include/footer-quick.jsp" flush="true" />
<jsp:include page="../include/footer.jsp" flush="true" />