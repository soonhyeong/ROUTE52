<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="<c:url value='/js/jquery.qrcode.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/qrcode.js'/>"></script>

<script type="text/javascript">
	var isOpen = false;
	var matchDay = "";
	
	$(function($) {
		initFooter();
		
		initQRCode();
	});
	
	$(document).ready(function() {
		setTimeout(function() {
			if ($(window).scrollTop() + $(window).height() >= getDocHeight() - 97) {
				$("#footerWrap1").animate({
					bottom : 97 - (getDocHeight() - ($(window).scrollTop() + $(window).height()))
				}, 0);	
			} else {
				$("#footerWrap1").animate({
					bottom : 0 
				}, 0);
			}
		}, 500);
	});
	
	$(window).scroll(function() {
		if ($(window).scrollTop() + $(window).height() >= getDocHeight() - 97) {
			$("#footerWrap1").animate({
				bottom : 97 - (getDocHeight() - ($(window).scrollTop() + $(window).height()))
			}, 0);	
		} else {
			$("#footerWrap1").animate({
				bottom : 0
			}, 0);
		}
	});
	
	function initQRCode() {
		var msNum = "${sessionScope.msMember.msNum}";
		
		if(msNum != "") {
			jQuery("#qr_msnum").qrcode({ 
		        render : "table",       
		        width  : 80,           
		        height : 80,          
		        text   : msNum
		    });
		}
	}
	
	function setSessionQuickMenu(value) {
		var sUrl = "<c:url value='/common/setSessionQuickMenu.do'/>";
		var sParams = String.format("openYn={0}", value);
		
		mAjax(sUrl, sParams, function(data) {
			
		});
	}

	function quickBox() {		
		var quickDiv = $("#quickOpneBox");
		var quickDiv2 = $("#quickBox");
		
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId == "") {
    		return;
		}
		
		if (isOpen) {
			quickDiv.show();
			quickDiv2.hide();
			if("${sessionScope.quick}" == "N") {
				setSessionQuickMenu("Y");
			}
		} else {
			quickDiv.hide();
			quickDiv2.show();
			if("${sessionScope.quick}" == "Y") {
				setSessionQuickMenu("N");
			}
		}

		isOpen = !isOpen;
	}

	function getDocHeight() {
	    var D = document;
	    return Math.max(
	        D.body.scrollHeight, D.documentElement.scrollHeight,
	        D.body.offsetHeight, D.documentElement.offsetHeight,
	        D.body.clientHeight, D.documentElement.clientHeight
	    );
	}

	function initFooter() {		
		var quickDiv = $("#quickOpneBox");
		var quickDiv2 = $("#quickBox");
		
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId == "") {
    		return;
		} else {
			if("${sessionScope.quick}" == "Y") {		
				quickDiv2.hide();
				quickDiv.show();	
				isOpen = false;
			} else {	
				quickDiv.hide();
				quickDiv2.show();
				isOpen = true;
			}
		}
		
		var sUrl = "<c:url value='/common/getFooterData.do'/>";
		var sParams = String.format("coDiv={0}", "65");

		mAjax(sUrl, sParams, function(data) {
			if (data.resultCode == "0000") {
				var rows = data.rows;

				for (i = 0; i < rows.length; i++) {
					var division = rows[i].DIVISION;
					var message = rows[i].MESSAGE;

					switch (division) {
					case "CP":
						$("#txtCoupon").html(String.format("{0}매", message));
						$("#imgIndexCouponCount").html(String.format("{0}장", message));
						if(message == "0") {
							$(".coupon_pop").hide();
						}
						break;
					case "SC":
						$("#txtScore").html(String.format("{0}타", message));
						break;
					case "BC":	
						$("#txtReservation").html(String.format("{0}건", message));
						break;
					case "MA":	
						matchDay = message.split(",")[0];
						var cnt = message.split(",")[1];
						
						$("#txtMatch").html(String.format("{0}건", cnt));
						break;
					}
				}
			}
		});
	}
	
	function onClickMatch() {
		if(matchDay == "X") return;
		
		MatchPopupOpen(matchDay);
	}
</script>

<div id="footerWrap1">
	<div id="quickBox">
		<div id="memberInfoBox">
			<div class="memberInfo"  onclick="quickBox(1);">
				<img src="<c:url value='/images/m_hills/myzone.png'/>" alt="">
			</div>
		</div>
	</div>
	
	<div id="quickOpneBox" style="display:none;">
		<div class="opneBox">
			<div class="myzoneTitle">
				<img class="title" src="<c:url value='/images/m_hills/myzone2.png'/>" onclick="quickBox(0);" alt="" >
				<%-- <div class="closeBox" ><img src="<c:url value='/images/m_hills/close_bt.png'/>"></div> --%>
			</div>
			<div class="myzoneBoxList">
				<ul class="myzoneBox">
					<li><img src="<c:url value='/images/m_hills/w_dot.png'/>" alt=""> 맞춤그린피 <span class="pink" id="txtMatch" onclick="onClickMatch()">0</span></li>
					<li><img src="<c:url value='/images/m_hills/w_dot.png'/>" alt=""> 쿠폰함 <span class="pink" id="txtCoupon" onclick="location.href='<c:url value='/m_hills/member/coupon.do'/>'"></span></li>
					<%-- <li><img src="<c:url value='/images/m_hills/w_dot.png'/>" alt=""> 포인트 <span class="pink">준비중</span></li> --%>
					<li><img src="<c:url value='/images/m_hills/w_dot.png'/>" alt=""> 최근스코어 <span class="pink" id="txtScore" onclick="location.href='<c:url value='/m_hills/member/score.do'/>'">0타</span></li>
					<li><img src="<c:url value='/images/m_hills/w_dot.png'/>" alt=""> 예약현황 <span class="pink" id="txtReservation" onclick="location.href='<c:url value='/m_hills/reservation/reservationCheck.do'/>'"></span></li>
					<li onclick="location.href='<c:url value='/m_hills/board/list.do?bbsType=51'/>'"><img src="<c:url value='/images/m_hills/w_dot.png'/>" alt=""> <span class="pink"> 제휴사 혜택</span></li>
				</ul>
				<div class="myzoneImg">
					<%-- <img src="<c:url value='/images/m_hills/QR_code.png'/>" alt=""> --%>				
					<div class="qrcode">
						<div id="qr_msnum"></div>
					</div>
					<p>MY QR CODE NUMBER</p>
				</div>
			</div>	
		</div><!-- memberInfoOpneBox End -->
	</div>
</div>

<!-- footer 영역 -->
<div id="footerWrap">
	<div class="termsBox">
		<div class="terms">
			<li><a href="<c:url value='/m_hills/index.do'/>">홈</a></li>
			<li><a href="javascript:void(0)" class="drawer-toggle">메뉴</a></li>
			<li><a href="<c:url value='/m_hills/board/list.do?bbsType=6'/>">이벤트</a></li>
			<li><a href="tel:031-940-9400" target="_blank">고객센터</a></li>
		</div>
	</div>
	<div class="footerBox">
		<div class="footer">				
			<p>경기도 파주시 광탄면 서원길 333</p>
			<p>COPYRIGHT ⓒ 서원레저(주) ALL RIGHT RESERVED.</p>
		</div>
	</div>
</div>