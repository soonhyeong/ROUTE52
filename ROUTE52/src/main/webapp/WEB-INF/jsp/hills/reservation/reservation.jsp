<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../include/header.jsp" />
<jsp:include page="../include/subTop.jsp" />

<script type="text/javascript">
	var rowData;
	var mDate;
	var mCos
	var mHole = "1";
	var sYear, fYear, sMonth, fMonth;
	
	$(document).ready(function() { 
		init();
		
		initTable();
	});
	
	function initMessage() {
		var sUrl = "<c:url value='/common/getMessage.do'/>";
		var sParams = "";
		
		sParams += String.format("&coDiv={0}", globals.coDiv.hills);
		sParams += String.format("&hpDiv={0}", "1");
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			if(data.resultCode == "0000") {
				var rows = data.rows;
				
				var container = $("#reserMsgContainer");
				container.empty();
				
				for(i=0; i<rows.length; i++) {
					var contents = rows[i].HP_CONTENTS;
					contents = replaceAll(contents, "\n", "<br>");
					var color = rows[i].HP_COLOR;
					var fontSize = rows[i].HP_FONT_SIZE;
					var boldYn = rows[i].HP_FONT_BOLDYN;
					
					var template = "<li style='line-height:24px; color:{0}; font-size:{1}px; {2}'><span class='infoDot'></span>{3}</li>";       
					
					container.append(String.format(template, "#" + color, fontSize, boldYn == "Y" ? "font-weight:bold;" : "", contents));
				}
			} else {
				alert(data.resultMessage);	
			}
			
			progressStop();
		});
	}
	
	
	function initBenner() {
		var sUrl = "<c:url value='/common/getMessage.do'/>";
		var sParams = "";
		
		sParams += String.format("&coDiv={0}", globals.coDiv.hills);
		sParams += String.format("&hpDiv={0}", "2");
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			if(data.resultCode == "0000") {
				var rows = data.rows;
				
				var container = $("#reserBennerContainer");
				container.empty();
				
				for(i=0; i<rows.length; i++) {
					var file = rows[i].HP_FILE_NAME;
					var link = rows[i].HP_LINK;
					
					var template = "<li><a href='{0}'><img src='<c:url value='/common/downloadImage.do?division=hills&folderName=benner&fileName={1}'/>'></a></li>";       
					container.append(String.format(template, link, file));
				}				
			} else {
				alert(data.resultMessage);	
			}
			
			progressStop();
		});
	}
	
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
		var date = new Date();
		sYear = date.yyyy();
		sMonth = date.mm();
		var date2 = addMonth(date.yyyymmdd(), 1);
		fYear = date2.yyyy();
		fMonth = date2.mm();

		var action = "${action}";
		var sDate = "${date}";
		var hole = "${hole}";
		
		onHoleTapChange("1");      
		
		if(action == "" || sDate == "") {
			if(hole == "11") {
				onHoleTapChange(hole);
			} else {
				initCalendar("#calendarBox1", sYear, sMonth);
				initCalendar("#calendarBox2", fYear, fMonth);
			}
		} else {
			mDate = sDate;
			
			mHole = "11";
			
			initCalendar("#calendarBox1", sYear, sMonth, "M");
			initCalendar("#calendarBox2", fYear, fMonth, "M");
			
			$("#hole1").removeClass("on");
			$("#hole11").addClass("on");
			
			doSearch();
		}
		
		var offset = $(".reserTabList").offset();
        $('html, body').animate({scrollTop : offset.top}, 400);
        
        initMessage();
        
        initBenner();
	}
	
	function onClickRow(i) {		
		if(rowData[i].BK_DAY == new Date().yyyymmdd()) {
			alert("??????????????? ???????????? ?????? ??????????????????.");
			return;
		}
		
		popupOpen("I", rowData[i], null);
	}
	
	function doSearchRoyal(date) {
		var sUrl = "<c:url value='/hills/reservation/getRoyalList.do'/>";
		var sParams = "";
		
		if(date != null && date != "") {
			sParams = "date=" + date;
		}
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {				
			if(data.resultCode == "0000") {
				var tBody = $("#royal-grid");				
				tBody.empty();
				
				rowData = data.rows;
				
				if(rowData.length == 0) {
					progressStop();
					
					return;
				}
				
				for(i=0; i<rowData.length; i++) {					
					var tr = $("<tr></tr>");
					var bkDay = getDateFormat(rowData[i].BK_DAY);
					var bkTime = rowData[i].BK_TIME;
					bkTime = bkTime.substring(0, 2) + ":" + bkTime.substring(2, 4);
					var amtGu = rowData[i].R_AMT_GU == "1" ? "<span class='icon_team'>???</span>" : "";
					var green = Number(rowData[i].R_GREEN_AMT);
					var cart = Number(rowData[i].R_CART_AMT);
					var food = Number(rowData[i].R_FOOD_AMT);
					var roundB = Number(rowData[i].R_ROUND_B_AMT);
					var roundA = Number(rowData[i].R_ROUND_A_AMT);
					var sum = food + roundB + roundA;
					var amt = green + cart + food + roundA + roundB;
					
					var include = "";
					if(roundB != 0 && roundA != 0) {
						include += "<b style='font-weight:400;' class='event_c'>????????? ???/??? ??????</b>";
					} else if(roundB != 0) {
						include += "<b style='font-weight:400;' class='event_c'>????????? ??? ??????</b>";
					} else if(roundA != 0) {
						include += "<b style='font-weight:400;' class='event_c'>????????? ??? ??????</b>";
					}
					if(food != 0) {
						include += include != "" ? " + " : ""; 
						include += "<b style='font-weight:400;' class='event_e'>???????????????</b>";
					}
					include = include != "" ? (" " + include) : ""
						 
					var td1 = $(String.format("<td>{0}/{1}/{2}</td>", bkDay.yyyy(), bkDay.mm(), bkDay.dd()));
					var td2 = $("<td>" + rowData[i].BK_COS_NM + "??????</td>");
					var td3 = $("<td>" + bkTime + "</td>");
					var td4 = $("<td>" + amtGu  + numberWithCommas(green) + "</td>");
					var td5 = $("<td>" + amtGu  + numberWithCommas(cart) + "</td>");
					var td6 = $("<td>" + amtGu  + numberWithCommas(sum) + "</td>");
					var td7 = $("<td>" + include + "</td>");
					var td8 = $("<td>" + amtGu + numberWithCommas(amt) + "</td>");
					var td9 = $("<td><a href='javascript:royalPopupOpen(rowData[" + i + "])' class='ryBtn orange'>????????????</a></td>");    					
					        
					tBody.append(tr.append(td1, td2, td3, td4, td5, td6, td7, td8, td9));
				}
			}
			
			progressStop();
		});
	}
	
	function doSearch() {	
		if(mHole == 'R') {
			doSearchRoyal();
			return;
		}
		
		if(mDate == null || mDate == '') {
			alert("????????? ???????????????.");
			return;
		}
		
		var date = new Date(mDate.substring(0, 4) + "-" + mDate.substring(4, 6) + "-" + mDate.substring(6, 8));
		$("#memDate").html(String.format("{0}??? {1}??? {2}??? &#40;{3}??????&#41;", date.yyyy(), date.mm(), date.dd(), date.week()));
		
		var sUrl;
		var sParams = "";
		
		/* if(mHole == '10') {
			sUrl = "<c:url value='/hills/reservation/getImminentTeeList.do'/>";
		} else {
			sUrl = "<c:url value='/hills/reservation/getTeeList.do'/>";
		} */
		
		sUrl = "<c:url value='/hills/reservation/getTeeList.do'/>";
		
		sParams += String.format("&date={0}", mDate);
		
		if(mCos != null && mCos != "") {
			sParams += String.format("&cos={0}", mCos);
		}
		
		if(mHole != null && mHole != "" && mHole != "11" && mHole != "10" && mHole != "12") {
			sParams += String.format("&roundf={0}", mHole);
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
				    
				    if(mHole == "11" && proDcGu == "X") {
						continue;     
					}
				    
				    if(mHole == "12" && (rGu == "X" || rGu == "1")) {
						continue;
					}
					
				    var col1 = $("<td>" + (i + 1) + "</td>"); 
				    var col2 = $("<td>" + bkDay + "</td>"); 
				    var col3 = $("<td>" + rowData[i].BK_COS_NM + "</td>");
				    var col4 = $("<td>" + bkTime + "</td>"); 
				    var col5 = $("<td>" + rowData[i].BK_ROUNDF_NM + "???</td>");
				    var col6 = $("<td>" + globals.personCd.codeNm(rowData[i].BK_PERSON_CD) + "</td>");
				    var col7 = $("<td>" + numberWithCommas(rowData[i].BK_BASIC_CHARGE) + "</td>");	
				    
				    var col8;
				    
				    /*
				    <span class='event_f'>????????????</span>
					<span class='event_e'>????????????</span>
					<span class='event_c'>???????????????</span>
					<span class='event_s'>????????????</span>
				    */
				    
				    if(bkCharge[2] == "M") {
				    	col8 = $("<td><span class='event_s'>????????????</span></td>");
					    col7.css("text-decoration", "line-through");
				    } else if(bkCharge[2] == "S") {
				    	if(rowData[i].MN_COST_YN == "Y") {
				    		if(mHole == "10") continue;
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
				    	if(mHole == "10") continue;
				    }
				    
				    if(rGu != "X") {
				    	if(rGu == "1") {
				    		col8 = $("<td><span class='event_r'>????????????</span></td>"); 
				    		event = "royalPopupOpen(rowData[" + i + "])";	
				    	} else if(rGu == "2") {
				    		col8 = $("<td><span class='event_e'>????????????</span></td>");
				    	} else if(rGu == "3") {
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
				    
				    var amtGu = rowData[i].R_AMT_GU == "1" && rGu == "1" ? "<span class='icon_team'>???</span>" : "";
				    
				    var col9 = $("<td class='last'>" + amtGu + numberWithCommas(bkChargeNm) + "</td>"); 				    
				    var col10 = $("<td><input type='button' class='orangeBtn' value='??????' onclick='" + event + "'></td>");
				    
				    row.append(col1,col2,col3,col4,col5,col6,col7,col8,col9,col10).appendTo(tBody); 
				}
				
				var offset = $(".courseTabList").offset();
		        $('html, body').animate({scrollTop : offset.top}, 400);
			}
			
			progressStop();
		});
	}
	
	function onHoleTapChange(hole, date) {
		mHole = hole;
		
		$(".reserBtnList").find("a").each(function() {
			if($(this).data("hole") == hole) {
				$(this).addClass("on");	
			} else {
				$(this).removeClass("on");
			}				
		});
		
		if(hole == '10'){
			$("#tabText").show();
			$("#tabText2").hide();
		}else if(hole == '11'){
			$("#tabText").hide();
			$("#tabText2").show();
		}else{
			$("#tabText").hide();
			$("#tabText2").hide();
		}
		
		if(hole == 'R'){
			$("#reservationContainer").hide();
			$("#royalContainer").show();
		} else {
			$("#reservationContainer").show();
			$("#royalContainer").hide();
			
			initCalendar("#calendarBox1", sYear, sMonth, hole == '11' ? "M" : null);
			initCalendar("#calendarBox2", fYear, fMonth, hole == '11' ? "M" : null);
			
			$("#time-grid").empty();
		}	
		
		if(mHole == "R") {
			doSearchRoyal(date);
		}
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
	
	function initCalendar(selector, year, month, match) {
		var sUrl = "<c:url value='/hills/reservation/getCalendar.do'/>";
		var sParams = "";
		
		/* if( match != null && match == "M" ) {
			sUrl = "<c:url value='/hills/reservation/getMatchCalendar.do'/>";
		} else {
			sUrl = "<c:url value='/hills/reservation/getCalendar.do'/>";
		} */

		sParams += String.format("&selYM={0}", year + month);	
		
		mAjax(sUrl, sParams, function(data) {			
			if(data.resultCode == "0000") {
				$(selector + " #calHeader").html(year + " / " + month);
				
				var currentDay = new Date().yyyymmdd();
				var tBody = $(selector + " #calendar-body");				
				tBody.empty();
				
				var rows = data.rows;
				var row = $("<tr></tr>");
				
				var fWeek = rows[0].CL_DAYDIV - 1;
				
				for(i=0; i<fWeek; i++) {
					row.append($("<td><div></div></td>"));
				}		
				
				for(i=0; i<rows.length; i++) {
					var td = $("<td><div>" + rows[i].DAYNUM + "</div></td>");
					
					if(rows[i].CL_BUSINESS != 5) {
						if(rows[i].CL_SOLAR == currentDay) {
							td.addClass('today');
							if(rows[i].BK_TEAM > 0) {
								td.data('date', rows[i].CL_SOLAR);
								td.on('click', function() {
									onClickDay($(this).data('date'));
								});	
							}
						} else if(rows[i].CL_SOLAR > currentDay) {
							if(rows[i].BK_TEAM > 0) {
								if(mHole == "10") {
									if(Number(rows[i].SALE_COST_YN) > 0 ) {
										td.data('date', rows[i].CL_SOLAR);
										td.addClass('sale');
										td.on('click', function() {
											onClickDay($(this).data('date'));
										});		
									}
								} else if(mHole == "11") {
									if(rows[i].MATCH_YN == "Y" ) {
										td.data('date', rows[i].CL_SOLAR);
										td.addClass('match');
										td.on('click', function() {
											onClickDay($(this).data('date'));
										});		
									}
								} else if(mHole == "12") {
									if(Number(rows[i].EARLY_CNT) > 0 ) {
										td.data('date', rows[i].CL_SOLAR);
										td.addClass('early');
										td.on('click', function() {
											onClickDay($(this).data('date'));
										});		
									}
								} else {
									td.data('date', rows[i].CL_SOLAR);
									if(rows[i].MATCH_YN == "Y") {
										td.addClass('match');
									} else if(Number(rows[i].EARLY_CNT) > 0 ) {
										td.addClass('early');
									} else if(Number(rows[i].SALE_COST_YN) > 0 ) {
										td.addClass('sale');
									} else {
										td.addClass('possible');
									}
									td.on('click', function() {
										onClickDay($(this).data('date'));
									});
								}
							} else if(Number(rows[i].ROYAL_CNT) > 0 && mHole == "1") {
								td.data('date', rows[i].CL_SOLAR);
								td.addClass('royal');
								td.on('click', function() {
									onHoleTapChange("R", $(this).data("date"));								
								});	
							} else {
								if(rows[i].BK_TEAM_ALL == 0) {
									td.addClass('beforeOpen');
								} else {
									td.addClass('deadLine');	
								}							
							}
						} 
					} else {
						td.addClass('holi');
					}					
					
					if(rows[i].CL_BUSINESS == 2) {
						td.children('div').addClass('blue');
					} else if(rows[i].CL_BUSINESS == 3 || rows[i].CL_BUSINESS == 4) {
						td.children('div').addClass('red');
					}
					
					row.append(td);
										
					if(rows[i].CL_DAYDIV == 7) {
						row.appendTo(tBody); 
						row = $("<tr></tr>");
					}					
				}			

				row.appendTo(tBody);     
			} else {
				alert(data.resultMessage);	
			}
		});	
	}
	
	function onClickDay(date) {
		mDate = date;
		
		doSearch();
	}
	
	function sNextMonth() {
		if(sMonth == "12") {
			sYear += 1;
			sMonth = "01";
		} else {
			sMonth = Number(sMonth) + 1;
			sMonth = (sMonth>9 ? '' : '0') + sMonth;
		}
		
		initCalendar("#calendarBox1", sYear, sMonth);
	}
	
	function sPrevMonth() {
		if(sMonth == "01") {
			sYear -= 1;
			sMonth = "11";
		} else {
			sMonth = Number(sMonth) - 1;
			sMonth = (sMonth>9 ? '' : '0') + sMonth;
		}
		
		initCalendar("#calendarBox1", sYear, sMonth);		
	}
	
	function fNextMonth() {
		if(fMonth == "12") {
			fYear += 1;
			fMonth = "01";
		} else {
			fMonth = Number(fMonth) + 1;
			fMonth = (fMonth>9 ? '' : '0') + fMonth;
		}
		
		initCalendar("#calendarBox2", fYear, fMonth);
	}
	
	function fPrevMonth() {
		if(fMonth == "01") {
			fYear -= 1;
			fMonth = "11";
		} else {
			fMonth = Number(fMonth) - 1;
			fMonth = (fMonth>9 ? '' : '0') + fMonth;
		}
		
		initCalendar("#calendarBox2", fYear, fMonth);		
	}
</script>

<div class="lnbBox">
	<div class="lnb">
		<img src="<c:url value='/images/hills/ico-home.png'/>" alt="">
		<p>??????????????? &nbsp;&nbsp;&nbsp; ??? <span>????????????</span></p>
	</div>
</div>

<div id="wrap">
	<div class="contents">
		<div class="reserTabList">
			<a href="<c:url value='/hills/reservation/reservation.do'/>" class="on">???????????????</a>	
			<a href="<c:url value='/hills/reservation/reservationWait.do'/>" class="">????????????</a>
			<a href="<c:url value='/hills/reservation/reservationCheck.do'/>" class="">????????????/??????</a>
		</div>
		
		<div class="reserBtnList">
			<a href="javascript:onHoleTapChange('1')" data-hole="1" id="hole1" class="reserBtn2 on"></a>
			<!-- <a href="javascript:onHoleTapChange('2')" data-hole="2" id="hole2" class="reserBtn1"></a>
			<a href="javascript:onHoleTapChange('5')" data-hole="5" id="hole5" class="reserBtn3"></a> -->
			<c:if test="${sessionScope.msMember.msDivision != '21' || sessionScope.msMember.msClass != '21'}">
			<a href="javascript:onHoleTapChange('10')" data-hole="10" id="hole10" class="reserBtn4 "></a>
			<a href="javascript:onHoleTapChange('11')" data-hole="11" id="hole11" class="reserBtn5 "></a>
			<a href="javascript:onHoleTapChange('R')" data-hole="R" id="holeR" class="reserBtn6 "></a>
			<a href="javascript:onHoleTapChange('12')" data-hole="12" id="hole12" class="reserBtn7"></a>
			</c:if>
		</div>

		<div id="tabText">
			<div class="reseveGrayBg">
				<h2 class="commonDot"> ???????????? ???????????????????</h2>
				<p>&bull; ???????????? ?????? ????????? ?????????????????? ?????????(1???~2??? ??????) ??????????????? ?????? ??????????????? ????????? ???????????? ????????? ???????????????,  ?????? ????????? ?????? ???????????? ??????, ?????? ?????? ???????????? 
?????? ????????? ?????? ?????? TIME?????????.<br>
&bull; ???????????? ?????? ????????? ?????? ???????????? ???????????? ?????????, ???????????? ????????? ?????? ???????????????.
				</p>
			</div>
		</div>
		
		<div id="tabText2">
			<div class="reseveGrayBg">
				<h2 class="commonDot"> ????????????</h2>
				<p>&bull; ???????????? ????????? ????????? ?????? ???????????????, ????????????, ???????????? ??????, ???????????? ??????, ????????? ?????? ?????? ??? ??????????????? ????????? ??????   ?????? ????????? ???????????? ?????? ?????? ????????? 
???????????????.</p>
				<h2 class="commonDot"> ?????? ????????? ?????????????</h2>
				<p>&bull; ?????? ???????????? ?????? ??????????????? 1~2??? ?????? ???????????? ????????? ?????? ??? ???, ?????? ?????? ???, ????????? ?????? ?????? ????????????  ????????? ?????? ?????? ?????? ???????????? ?????? ??? ????????????.<br>&bull; ?????? ????????? ??? ????????????, ?????? ????????? ?????? ???????????? ????????????. </p>
			</div>
			<div>
			<img src="<c:url value='/images/hills/tabsubImage.jpg'/>" alt="">
			</div>
		</div>
	<div id="royalContainer">
		<div class="subTitle">
			<span class="title">???????????? ????????????</span>
		</div>
		<div class="subLine"></div>
		
		<div class="midTitleBox">
			<span class="commonDot"> ????????????????????? ???????????? ??????</span>
		</div>
		
		<div class="reserExTxt1">
			<ul>
				<li>&bull; ???????????? ????????? ?????? ????????? ?????????????????? 4~6??? ??? ????????? ??????????????? ???????????????.</li>
				<li>&bull; ???????????? ????????? ?????? ????????? ???????????? ????????? ????????? ???????????? ??? ????????? ?????? ????????? ?????? 0~3??? ??? ?????? ?????? ???????????? ???????????????.</li>
				<li>&bull; ???????????? ????????? ?????? ????????? ?????? ?????? ??? ??? ????????? 10% ???????????? ?????????????????? ????????? ???????????????.</li>
				<li>&bull; ?????? ?????? ?????? ????????? 9~4??? ??? ?????? ??? ???????????? 50% ??????, ????????? 3~0??? ??? ?????? ??? ????????? ??????(??????X)?????????. </li> 
				<li class="red">&bull; ????????????????????? ??????????????? ????????? ???????????? ???????????? ???????????? ?????? ??? ????????? ???????????????.</li>
			</ul>
		</div>
		<br><br><br><br>
		
		<div class="midTitleBox">
			<span class="commonDot"> ????????????????????? ???????????? ?????? ??????</span>
		</div>
		
		<div class="teamGuideBox">
			<div class="teamGrayBox requestGrayBox">			
				<div class="requestTurnBox">
					<ul class="requestTurn">
						<li class="turnImg"><img src="<c:url value='/images/hills/request04.png'/>" alt=""/></li>
						<li class="turnTxt"><span class="bold">01.</span>????????????</li>
					</ul>
					<div class="requestArrow"><img src="<c:url value='/images/hills/requestArrow.png'/>" alt=""/></div>
					<ul class="requestTurn">
						<li class="turnImg"><img src="<c:url value='/images/hills/ry01.png'/>" alt=""/></li>
						<li class="turnTxt"><span class="bold">02.</span>???????????? ????????????</li>
					</ul>
					<div class="requestArrow"><img src="<c:url value='/images/hills/requestArrow.png'/>" alt=""/></div>
					<ul class="requestTurn">
						<li class="turnImg"><img src="<c:url value='/images/hills/request03.png'/>" alt=""/></li>
						<li class="turnTxt"><span class="bold">03.</span>???????????? ??????</li>
					</ul>
					<div class="requestArrow"><img src="<c:url value='/images/hills/requestArrow.png'/>" alt=""/></div>
					<ul class="requestTurn">
						<li class="turnImg"><img src="<c:url value='/images/hills/ry03.png'/>" alt=""/></li>
						<li class="turnTxt"><span class="bold">04.</span>????????? ????????????</li>
					</ul>
					<div class="requestArrow"><img src="<c:url value='/images/hills/requestArrow.png'/>" alt=""/></div>
					<ul class="requestTurn">
						<li class="turnImg"><img src="<c:url value='/images/hills/ry04.png'/>" alt=""/></li>
						<li class="turnTxt"><span class="bold">05.</span>?????? ?????? ??????</li>
					</ul>
					<div class="requestArrow"><img src="<c:url value='/images/hills/requestArrow.png'/>" alt=""/></div>
					<ul class="requestTurn">
						<li class="turnImg"><img src="<c:url value='/images/hills/ry02.png'/>" alt=""/></li>
						<li class="turnTxt"><span class="bold">06.</span>????????? ??????</li>
					</ul>
				</div>	
			</div>
		</div>
		<br><br>
		<div class="midTitleBox">
			<span class="commonDot"> ????????????????????? ???????????? ?????? ??????</span>
		</div>
		
		<div class="royalWrap">
			<div class="ryBox">
				<img src="<c:url value='/images/hills/ryImg01.jpg'/>" alt=""/>
				<p class="ryText">1??? ?????????</p>
				<div class="ryPlus">+</div>
			</div>
			<div class="ryBox">
				<img src="<c:url value='/images/hills/ryImg02.jpg'/>" alt=""/>
				<p class="ryText">1??? ?????????</p>
				<div class="ryPlus">+</div>
			</div>
			<div class="ryBox last">
				<img src="<c:url value='/images/hills/ryImg03.jpg'/>" alt=""/>
				<p class="ryText1">????????? ??? ??????</p>
				<!-- <div class="ryPlus1">OR</div>-->
			</div>
			<div class="ryBox last">
				<img src="<c:url value='/images/hills/ryImg04.jpg'/>" alt=""/>
				<p class="ryText1">9??? ????????? ?????????</p>
				<!-- <div class="ryPlus1">OR</div>-->
			</div>
			<div class="ryBox last">
				<img src="<c:url value='/images/hills/ryImg05.jpg'/>" alt=""/>
				<p class="ryText1">????????? ??? ??????</p>
			</div>
			<p class="ryText2" style="right:110px;width:588px;">1??? ?????????</p> 
		</div>	
		
		<div class="reserExTxt1">
			<ul>
				<li>????????? ????????? 1??? 4??? ?????? ???????????? ????????????, 1??? ?????????+1??? ?????????+1??? ???????????? ???????????? ????????????.</li>
				<li>???????????? ???????????? ?????? ?????? ????????? ????????? ?????? ???????????? ?????? ????????? ???????????????.</li>
				<li>????????? ?????? ?????? ?????? ??? ???????????? ???????????? ????????? ?????? ????????? ?????? ?????? ????????????.</li>
			</ul>
		</div>
		<br><br>   
		
		<table class="commonTable" id="">
			<caption>????????? ?????? ??????,????????? ?????? ??????</caption>
			<colgroup>
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="*">
				<col width="10%">
				<col width="20%">
				<col width="*">
				<col width="*">
			</colgroup>
			<thead>
				<tr>
					<th>??????</th>
					<th>??????</th>
					<th>??????</th>
					<th>?????????</th>
					<th>?????????</th>
					<th colspan="2">?????????</th>
					<th>????????? ??????</th>
					<th>??????</th>
				</tr>
			</thead>
			<tbody id="royal-grid">
			</tbody>
		</table>
	</div>
		<div id="reservationContainer">
		<input type="button" class="reserEnter basic" id="searchPopupButton" value="" onclick="reservePopupOpen(2)">  

		<div class="subTitle">
			<span class="title">????????????</span>
			<span class="titleDes">????????? ????????? ?????? ??? ????????????.</span>
		</div>
		<div class="subLine"></div>

		<!-- reserCalBox -->
		<div class="reserCalBox">
			<div style="width:600px;float:left;padding-left:50px;">
				<div class="box" id="calendarBox1" style="margin-bottom:5px">
				  <div class="monthChoice">
					<span><a href="javascript:sPrevMonth()"><img src="<c:url value='/images/valley/arrow_l.png'/>" style="width:18px; margin-top: 6px;" alt="??? ???"></a></span>
					<span class="month" id="calHeader"></span>
					<span><a href="javascript:sNextMonth()"><img src="<c:url value='/images/valley/arrow_r.png'/>" style="width:18px; margin-top: 6px;" alt="?????????"></a></span>
				  </div>
				  <table class="mainCalendar" summary="????????? ??????" cellspacing="5">
					<caption>
					????????? ??????
					</caption>
					<colgroup>
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					</colgroup>
					<tr>
						<th scope="col" class="sun">SUN</th>
						<th scope="col">MON</th>
						<th scope="col">TUE</th>
						<th scope="col">WEN</th>
						<th scope="col">THU</th>
						<th scope="col">FRI</th>
						<th scope="col">SAT</th>
					  </tr>
					<tbody id="calendar-body">
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
					</tbody>
				  </table>

				  <div class="resChoice">
					<img src="<c:url value='/images/hills/dot2_blue.png'/>" alt=""><span> ????????????</span>
					<%-- <img src="<c:url value='/images/hills/dot2_red.png'/>" alt=""><span> ???????????????</span> --%>
					<img src="<c:url value='/images/hills/dot2_green.png'/>" alt=""><span> ??????</span> 
					<img src="<c:url value='/images/hills/dot2_purple.png'/>" alt=""><span> ????????????</span>					
					<img src="<c:url value='/images/hills/dot2_orange.png'/>" alt=""><span> ???????????????</span>
					<img src="<c:url value='/images/hills/dot2_royal.png'/>" alt=""><span> ????????????</span>
				  </div>
				</div>
				
				<div class="box" id="calendarBox2">
				  <div class="monthChoice">
					<span><a href="javascript:fPrevMonth()"><img src="<c:url value='/images/valley/arrow_l.png'/>" style="width:18px; margin-top: 6px;" alt="??? ???"></a></span>
					<span class="month" id="calHeader"></span>
					<span><a href="javascript:fNextMonth()"><img src="<c:url value='/images/valley/arrow_r.png'/>" style="width:18px; margin-top: 6px;" alt="?????????"></a></span>
				  </div>
				  <table class="mainCalendar" summary="????????? ??????" cellspacing="5">
					<caption>
					????????? ??????
					</caption>
					<colgroup>
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					<col width="*">
					</colgroup>
					<tr>
						<th scope="col" class="sun">SUN</th>
						<th scope="col">MON</th>
						<th scope="col">TUE</th>
						<th scope="col">WEN</th>
						<th scope="col">THU</th>
						<th scope="col">FRI</th>
						<th scope="col">SAT</th>
					  </tr>
					<tbody id="calendar-body">
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
						<tr><td colspan="7"><div></div></td></tr>
					</tbody>
				  </table>

				  <div class="resChoice">
					<img src="<c:url value='/images/hills/dot2_blue.png'/>" alt=""><span> ????????????</span>
					<%-- <img src="<c:url value='/images/hills/dot2_red.png'/>" alt=""><span> ???????????????</span> --%>
					<img src="<c:url value='/images/hills/dot2_green.png'/>" alt=""><span> ??????</span>
					<img src="<c:url value='/images/hills/dot2_purple.png'/>" alt=""><span> ????????????</span>				
					<img src="<c:url value='/images/hills/dot2_orange.png'/>" alt=""><span> ???????????????</span>
					<img src="<c:url value='/images/hills/dot2_royal.png'/>" alt=""><span> ????????????</span>
				  </div>
				</div>
			</div>
		<!-- box Right -->
				<div class="box-right">
					<div class="midTitleBox">
						<span class="commonDot"> ????????????</span>
						<a class="reserGuide" href="<c:url value='/hills/reservation/reservationGuide.do'/>"> <img src="<c:url value='/images/hills/red_arrow.png'/>" alt=""> ??????????????? ???????????????</a>
					</div>	
					<div class="grayCommonBox">
						<ul class="memList">
							<li>??? ????????? : ${sessionScope.msMember.msName}</li>
							<li>??? ????????? : <span id="memDate"></span></li>
						</ul>
					</div>
					<ul class="reserExTxt" id="reserMsgContainer">
					</ul>
					<div class="rBanner">
						<ul id="reserBennerContainer"> 
						</ul>					
					</div>
				</div>
			</div><!-- reserCalBox End-->
			
			
		<!-- ??????/???????????? ?????? ????????? -->
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
			<tr>
				<td colspan="10">
					<span class="txt">??? ?????? ????????? ???????????? ???????????? ????????? ????????? ?????? ???????????????. </span>
				</td>
			</tr>
		</table>	
		</div>
		</div>
	</div><!-- contents End -->
<jsp:include page="../include/footer-quick.jsp" flush="true" />
<jsp:include page="../include/footer.jsp" flush="true" />