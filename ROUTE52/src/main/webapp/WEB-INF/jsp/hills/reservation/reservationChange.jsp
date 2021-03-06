<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../include/header.jsp" />
<jsp:include page="../include/subTop.jsp" />
<script type="text/javascript">

	var rowData;
	var mCos;

	$(document).ready(function() { 
		init();
		
		initTable();
	});
	
	function initTable() {
		var $table = $("#time-table");
		var $header = $table.children("tbody").first().children("tr");
		
		$header.children("th").each(function(index, element) {
			var selector = "time-grid";
			var imgAsc = "<c:url value='/images/hills/t_arw.png'/>";
			var imgDesc = "<c:url value='/images/hills/t_arw1.png'/>";
			
			if(index == 2 || index == 3 || index == 8) {
				var type = index == 8 ? "n" : "s";
				var sLen = $(this)[0].innerText.length;
				var fSize = Number($(this).css("font-size").replace("px", "")) / 2;
				var mid = Number($(this).css("width").replace("px", "")) / 2;
				var left = mid + (sLen * fSize);
				
				$(this).css("background-image", "url(" + imgAsc + "), url(" + imgDesc + ")");
				$(this).css("background-position", String.format("{0}px 50%, {1}px 50%", left, left + 10));
				$(this).css("background-size", "12px 7px, 12px 7px");
				$(this).css("background-repeat", "no-repeat");
				$(this).css("cursor", "pointer");
				
				$(this).data("order", "asc");
				$(this).data("left", left);
				
				$(this).on("click", function() {
					sortTable(selector, type, $(this).data("order"), index);
					if($(this).data("order") == "asc") {
						$(this).css("background-image", "url(" + imgAsc + ")");
						$(this).data("order", "desc");
					} else {
						$(this).css("background-image", "url(" + imgDesc + ")");
						$(this).data("order", "asc");
					}
					$(this).css("background-position", String.format("{0}px 50%", $(this).data("left")));
					$(this).css("background-size", "12px 7px");
				});
			}
		});
	}
	
	function init() {
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId == "") {
			alert("????????? ??? ?????? ???????????????.");
			location.href = "<c:url value='/hills/member/login.do'/>";	
		}
		
		var bkName = "${bkName}";
		var bkDay = getDateFormat("${bkDay}");
		bkDay = String.format("{0}??? {1}??? {2}??? &#40;{3}??????&#41;", bkDay.yyyy(), bkDay.mm(), bkDay.dd(), bkDay.week());
		var bkPhone = String.format("{0}-{1}-{2}", "${phone1}", "${phone2}", "${phone3}");
		var bkCos = "${bkCosNm}";
		var bkRoundf = "${bkRoundfNm}";
		var bkTime = "${bkTime}";
		bkTime = bkTime.substring(0, 2) + ":" + bkTime.substring(2, 4);
		var bkPerson = "${person}";
		var bhChargeNm = "${bkChargeNm}";

		if("${agencyYn}" == "Y"){
			$("#txtName").val(bkName);
			$("#txtPhone").val(bkPhone);
		} else {
			$("#txtName").html(bkName);
			$("#txtPhone").html(bkPhone);
		}
		$("#txtDate").html(bkDay);
		$("#txtCos").html(String.format("{0}?????? / {1} / {2}", bkCos, bkRoundf, bkTime));
		$("#selPerson").val(bkPerson);
		$("#txtCost").html(numberWithCommas(bhChargeNm));
		
		if(globals.personCd.three != "${personCd}") {
			$("#selPerson").prop("disabled", true);
		}
		
		doSearch();
	}
	
	function doSearch() {	
		var sUrl = "<c:url value='/hills/reservation/getTeeList.do'/>";
		var sParams = "";
		
		sParams += String.format("&date={0}", "${bkDay}");
		
		if(mCos != null && mCos != "") {
			sParams += String.format("&cos={0}", mCos);
		}
		
		if($("#cbSelTime").val() != "") {
			var sTime, eTime;
			
			sTime = Number($("#cbSelTime").val());
			eTime = sTime + 99;
			
			sParams += String.format("&sTime={0}", sTime);
			sParams += String.format("&eTime={0}", eTime);
		}
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {				
			if(data.resultCode == "0000") {
				var tBody = $("#time-grid");				
				tBody.empty();
				
				rowData = data.rows;
				
				if(rowData.length == 0) {
					progressStop();
					
					return;
				}
				
				for(i=0; i<rowData.length; i++) {					
					var row = $("<tr></tr>"); 
					var event = "onClickRow(" + i + ")";

					var bkDay = rowData[i].BK_DAY;
					bkDay = bkDay.substring(0, 4) + "/" + bkDay.substring(4, 6) + "/" + bkDay.substring(6, 8);
					var bkTime = rowData[i].BK_TIME;
					bkTime = (Number(bkTime) < 1200 ? "??????" : "??????") + " " + bkTime.substring(0, 2) + ":" + bkTime.substring(2, 4);
					var bkCharge;
					if(rowData[i].BK_CHARGE != null && rowData[i].BK_CHARGE != ""){
						bkCharge = rowData[i].BK_CHARGE.split(",")	
					}			    
				    var bkChargeNm = bkCharge[1];
					var proDcGu = rowData[i].PRO_DC_GU;
					var proDcVal = rowData[i].PRO_DC_VALUE;	
				    var rGu = rowData[i].R_GU;
				    
				    var col1 = $("<td>" + (i + 1) + "</td>"); 
				    var col2 = $("<td>" + bkDay + "</td>"); 
				    var col3 = $("<td>" + rowData[i].BK_COS_NM + "</td>");
				    var col4 = $("<td>" + bkTime + "</td>"); 
				    var col5 = $("<td>" + rowData[i].BK_ROUNDF_NM + "???</td>");
				    var col6 = $("<td>" + globals.personCd.codeNm(rowData[i].BK_PERSON_CD) + "</td>");
				    var col7 = $("<td>" + numberWithCommas(rowData[i].BK_BASIC_CHARGE) + "</td>");	
				    
				    var col8;
				    				    
				    if(bkCharge[2] == "M") {
				    	col8 = $("<td><span class='event_s'>????????????</span></td>");
					    col7.css("text-decoration", "line-through");
				    } else if(bkCharge[2] == "S") {
				    	if(rowData[i].MN_COST_YN == "Y") {
				    		col7 = $("<td>" + numberWithCommas(bkCharge[1]) + "</td>");	
				    		col8 = $("<td></td>");
				    	} else {
				    		col7.css("text-decoration", "line-through");
				    		col8 = $("<td><span class='event_s'>????????????</span></td>");
				    	}
				    } else if(bkCharge[2] == "R") {
				    	col8 = $("<td><span class='event_s'>??????</span></td>");
					    col7.css("text-decoration", "line-through");
				    } else {
				    	col8 = $("<td></td>");
				    }
				    
				    if(rGu != "X") {
				    	if(rGu == "1") {
				    		continue;
				    	} else if(rGu == "2") {
				    		col8 = $("<td><span class='event_e'>????????????</span></td>");
				    	} 
				    	else if(rGu == "3") {
				    		col8 = $("<td><span class='event_f'>????????????</span></td>");
				    	}				    	
					    col7.css("text-decoration", "line-through");
					    
					    bkChargeNm = Number(rowData[i].R_GREEN_AMT) + Number(rowData[i].R_CART_AMT) + Number(rowData[i].R_FOOD_AMT) + Number(rowData[i].R_ROUND_B_AMT) + Number(rowData[i].R_ROUND_A_AMT);
				    }
				    
				    if(proDcGu != "X") {
				    	var basicCharge = rowData[i].BK_BASIC_CHARGE;
				    	var defaultCharge = bkChargeNm;
					    
				    	if(proDcGu == "1") {					    	
						    bkChargeNm = Number(proDcVal) / 4;
					    } else if(proDcGu == "2") {	
						    bkChargeNm = Number(basicCharge) - (Number(basicCharge) * Number(proDcVal) / 100);					    	
					    } else if(proDcGu == "3") {
					    	bkChargeNm = Number(basicCharge) - Number(proDcVal);
					    } 
				    	
				    	if(Number(bkChargeNm) <= Number(defaultCharge)) {
				    		var advYn = rowData[i].PRO_ADV_YN;
				    		var foodYn = rowData[i].PRO_FOOD_YN;
				    		var sTag = ""			    		
				    		if(advYn == "Y") {
				    			sTag = "????????????";
				    		} else {
				    			sTag = "??????";
				    		}
				    		if(foodYn == "Y") { 
				    			sTag += "+??????";
				    		}
				    		
				    		col8 = $("<td><span class='event_c'>" + sTag + "</span></td>");
						    col7.css("text-decoration", "line-through");
				    	} else {
				    		bkChargeNm = defaultCharge;
				    	}
				    }
				    
				    var col9 = $("<td class='last'>" + numberWithCommas(bkChargeNm) + "</td>"); 				    
				    var col10 = $("<td><input type='button' class='orangeBtn' value='??????' onclick='" + event + "'></td>");
				    
				    row.append(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10).appendTo(tBody); 
				}
				
				/* for(i=0; i<rowData.length; i++) {
					var row = $("<tr></tr>"); 

					var bkDay = rowData[i].BK_DAY;
					bkDay = bkDay.substring(0, 4) + "/" + bkDay.substring(4, 6) + "/" + bkDay.substring(6, 8);
					var bkTime = rowData[i].BK_TIME;
					bkTime = (Number(bkTime) < 1200 ? "??????" : "??????") + " " + bkTime.substring(0, 2) + ":" + bkTime.substring(2, 4);
					var bkCharge;
					if(rowData[i].BK_CHARGE != null && rowData[i].BK_CHARGE != ""){
						bkCharge = rowData[i].BK_CHARGE.split(",")	
					}
					var proDcGu = rowData[i].PRO_DC_GU;
					var proDcVal = rowData[i].PRO_DC_VALUE;			    
				    var bkChargeNm = bkCharge[1];
					
				    var col1 = $("<td>" + (i + 1) + "</td>"); 
				    var col2 = $("<td>" + bkDay + "</td>"); 
				    var col3 = $("<td>" + rowData[i].BK_COS_NM + "</td>");
				    var col4 = $("<td>" + bkTime + "</td>"); 
				    var col5 = $("<td>" + rowData[i].BK_ROUNDF_NM + "???</td>");
				    var col6 = $("<td>" + globals.personCd.codeNm(rowData[i].BK_PERSON_CD) + "</td>");
				    var col7 = $("<td>" + numberWithCommas(rowData[i].BK_BASIC_CHARGE) + "</td>");		
				    var col8;
				    if(bkCharge[2] == "M") {
				    	col8 = $("<td><span class='greenBtn'>??????</span></td>");
					    col7.css("text-decoration", "line-through");
				    } else if(bkCharge[2] == "S") {
				    	col8 = $("<td><span class='greenBtn'>??????</span></td>");
					    col7.css("text-decoration", "line-through");
				    } else if(bkCharge[2] == "R") {
				    	col8 = $("<td><span class='blueBtn'>??????</span></td>");
					    col7.css("text-decoration", "line-through");
				    } else {
				    	col8 = $("<td></td>");
				    }
				    
				    if(proDcGu != "X") {
				    	var basicCharge = rowData[i].BK_BASIC_CHARGE;
				    	var defaultCharge = bkChargeNm;
					    
				    	if(proDcGu == "1") {					    	
						    bkChargeNm = Number(proDcVal) / 4;
					    } else if(proDcGu == "2") {	
						    bkChargeNm = Number(basicCharge) - (Number(basicCharge) * Number(proDcVal) / 100);					    	
					    } else if(proDcGu == "3") {
					    	bkChargeNm = Number(basicCharge) - Number(proDcVal);
					    } 
				    	
				    	if(Number(bkChargeNm) <= Number(defaultCharge)) {
					    	col8 = $("<td><span class='orangeBtn'>??????</span></td>");
						    col7.css("text-decoration", "line-through");
				    	} else {
				    		bkChargeNm = defaultCharge;
				    	}
				    }
				    
				    var col9 = $("<td class='last'>" + numberWithCommas(bkCharge[1]) + "</td>");				    
				    var col10 = $("<td><input type='button' class='orangeBtn' value='??????' onclick='onClickRow(" + i + ")'></td>");
				    
				    row.append(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10).appendTo(tBody); 
				} */
			}
			
			progressStop();
		});
	}
	
	function onClickRow(i) {
		var beforeData = {
			bkDay : "${bkDay}",
			bkCos : "${bkCos}",
			bkTime : "${bkTime}"
		}
		
		popupOpen("U", rowData[i], beforeData);
	}
	
	function onCosTapChange(cos) {
		if(cos == '') {
			$(".courseTabList #cosAll").addClass("on");
			$(".courseTabList #cosA").removeClass("on");
			$(".courseTabList #cosB").removeClass("on");
			$(".courseTabList #cosC").removeClass("on");
		} else if(cos == 'A') {
			$(".courseTabList #cosAll").removeClass("on");
			$(".courseTabList #cosA").addClass("on");
			$(".courseTabList #cosB").removeClass("on");
			$(".courseTabList #cosC").removeClass("on");			
		} else if(cos == 'B') {
			$(".courseTabList #cosAll").removeClass("on");
			$(".courseTabList #cosA").removeClass("on");
			$(".courseTabList #cosB").addClass("on");
			$(".courseTabList #cosC").removeClass("on");
		} else if(cos == 'C') {
			$(".courseTabList #cosAll").removeClass("on");
			$(".courseTabList #cosA").removeClass("on");
			$(".courseTabList #cosB").removeClass("on");	
			$(".courseTabList #cosC").addClass("on");
		}
		
		mCos = cos;
		doSearch(); 
	}
	
	function doChangePerson() {
		var sUrl = "<c:url value='/hills/reservation/changeReservationPerson.do'/>";
		var sParams = "";
		
		var bkDay = "${bkDay}";
		var bkCos = "${bkCos}";
		var bkTime = "${bkTime}";
		var bkRsvNo = "${bkRsvNo}";
		var bkPerson = $("#selPerson").val();
		var bkName, bkPhone;

		sParams += String.format("&bkDay={0}", bkDay);
		sParams += String.format("&bkCos={0}", bkCos);
		sParams += String.format("&bkTime={0}", bkTime);
		sParams += String.format("&bkRsvNo={0}", bkRsvNo);		
		sParams += String.format("&bkPerson={0}", bkPerson);
		
		if("${agencyYn}" == "Y") {
			bkName = $("#txtName").val();
			bkPhone = $("#txtPhone").val();
			bkPhone = replaceAll(bkPhone, " ", "");
			bkPhone = replaceAll(bkPhone, "-", "");
			sParams += String.format("&bkName={0}", bkName);
			sParams += String.format("&bkPhone={0}", bkPhone);
		}
		
		progressStart();		
		
		mAjax(sUrl, sParams, function(data) {
			progressStop();

			alert(data.resultMessage);				
		});	
	}
	
</script>

<div class="lnbBox">
	<div class="lnb">
		<img src="<c:url value='/images/hills/ico-home.png'/>" alt="">
		<p>????????? &nbsp;&nbsp;&nbsp; ??? ???????????? &nbsp;&nbsp;&nbsp; ??? <span>??????</span></p>
	</div>
</div>

<div id="wrap">
	<div class="contents">		
		<div class="myzoneTabList8">
			<a href="<c:url value='/hills/reservation/reservationCheck.do'/>" class="on">????????????/??????</a>
			<a href="<c:url value='/hills/member/stateVisit.do'/>" class="">????????????</a>
			<a href="<c:url value='/hills/member/statePenal.do'/>" class="">????????????</a>
			<a href="<c:url value='/hills/member/stateScore.do'/>" class="">???????????????</a>
			<a href="<c:url value='/hills/member/coupon.do'/>" class="">?????????</a>
			<a href="javascript:alert('??????????????????.')" class="">???????????????</a>
			<a href="<c:url value='/hills/board/list.do?bbsType=9'/>" class="">???????????????</a>
			<a href="<c:url value='/hills/member/memModify.do'/>" class="">??????????????????</a>
		</div>
		
		<div class="subTitle">
			<span class="title">????????????</span>
			<span class="titleDes">???????????? ????????? ???????????? ??? ????????????.</span>
		</div>
		<div class="subLine"></div>		

		<div class="midTitleBox">
			<span class="commonDot"> ????????????</span>
		</div>

		<div class="infoChangeBox">
			<ul class="infoList">
				<li>
					<span class="infoDot"></span><span class="title">?????????</span>
					<c:if test="${agencyYn eq 'Y'}">
						<input type="text" id="txtName" style="width:150px;height:30px; border:1px solid #ddd;"> 
					</c:if>
					<c:if test="${agencyYn eq 'N'}">
						<span id="txtName"></span>
					</c:if>
				</li>
				<li>
					<span class="infoDot"></span><span class="title">????????????</span><span class="blue" id="txtDate"></span>
				</li>
				<li>
					<span class="infoDot"></span><span class="title">?????????</span>
					<c:if test="${agencyYn eq 'Y'}">
						<input type="text" id="txtPhone" style="width:150px;height:30px; border:1px solid #ddd;"> 
					</c:if>
					<c:if test="${agencyYn eq 'N'}">
						<span id="txtPhone"></span>
					</c:if>
				</li>
				<li>
					<span class="infoDot"></span><span class="title">??????/???/??????</span><span id="txtCos"></span>
				</li>
				<li>
					<span class="infoDot"></span><span class="title">??????</span>
					<select name="" id="selPerson" class="select-arrow">
						<option value="3">3???</option>
						<option value="4">4???</option>
					</select>
				</li>
				<li>
					<span class="infoDot"></span><span class="title">??????????????????</span><span class="orangeRed" id="txtCost"></span>
				</li>
			</ul>
			<div class="dotLine"></div>
			<div class="info_Ch"><a class="cancel" href="javascript:doChangePerson()">????????????</a></div>
		</div>


		<div class="courseTabList">
			<a href="javascript:onCosTapChange('')" class="on" id="cosAll">????????????</a>
			<a href="javascript:onCosTapChange('A')" class="" id="cosA">???????????????</a>
			<a href="javascript:onCosTapChange('B')" class="" id="cosB">???????????????</a>
			<a href="javascript:onCosTapChange('C')" class="" id="cosC">???????????????</a>
			
			<div class="selectBox">
				<select name="" id="cbSelTime" class="select-arrow" onchange="doSearch()">
					<option value=''>??????</option>
					<option value='500'>5???</option>
					<option value='600'>6???</option>
					<option value='700'>7???</option>
					<option value='800'>8???</option>
					<option value='900'>9???</option>
					<option value='1000'>10???</option>
					<option value='1100'>11???</option>
					<option value='1200'>12???</option>
					<option value='1300'>13???</option>
					<option value='1400'>14???</option>
					<option value='1500'>15???</option>
					<option value='1600'>16???</option>
					<option value='1700'>17???</option>
					<option value='1800'>18???</option>
				</select>
			</div>
			<span class="timeHits">?????? ???????????????</span>
		</div>
		<table class="commonTable" id="time-table">
			<caption>????????? ?????? ??????,????????? ?????? ??????</caption>
			<colgroup>
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="13%">
				<col width="*">
				<col width="*">
			</colgroup>
			<tr>
				<th>??????</th>
				<th>?????????</th>
				<th>??????</th>
				<th>??????</th>
				<th>???</th>
				<th>??????</th>
				<th>??????????????????</th>
				<th>?????????</th>
				<th>???????????????</th>
				<th>??????</th>				
			</tr>
			<tbody id="time-grid"></tbody>
		</table>
	</div>
</div>

<jsp:include page="../include/footer-quick.jsp" flush="true" />
<jsp:include page="../include/footer.jsp" flush="true" />