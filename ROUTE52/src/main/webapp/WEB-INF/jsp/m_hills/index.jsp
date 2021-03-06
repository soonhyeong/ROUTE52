<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="../m_hills/include/header.jsp" />
<jsp:include page="../m_hills/include/pop_main.jsp" />

<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
<script type="text/javascript">
	var rowData;
	var mDate;
	var mCos, mPart;
	var isReserOpen = false;

	$(document).ready(function() { 
		init();
		
		//TpopupOpen();
		if(getCookie("mobileMainPopup") != "Y"){
			doSearchPopup();
		}
		
		doSearchBenner();
		
		initTable();
		
		doSearchYoutube();
	});

	function doSearchPopup() {
		var sUrl = "<c:url value='/admin/getPopup.do'/>";
		var sParams = "";
		
		sParams += String.format("coDiv={0}", "65");
		
		mAjax(sUrl, sParams, function(data) {	     		
			if(data.resultCode = "0000") {
				$(".slider1").empty();
				
				var rows = data.rows.list2;
				
				if(rows.length > 0) {
					$("#pop1").show();
					
					var bucket = "hills"
					var template = "<li><a href='{0}'><img src='{1}'></a></li>";
				    
					for(i=0; i<rows.length; i++) {
						var fileName = rows[i].HP_FILE_NAME;    
						var originName = rows[i].HP_ORIGIN_FILE_NAME;					
						var image = String.format("<c:url value='/common/downloadImage.do?division={0}&folderName=popup&fileName={1}'/>", bucket, fileName) ;
						var link = rows[i].HP_LINK;
						
						$(".slider1").append(String.format(template, link, image));
					}
					
					$('.slider1').bxSlider({
					    mode:'horizontal',
					    speed : 300,
					    pause : 3000,
					    auto: true,
					    controls: true,
					    pager:false
					});
				}
			} else {
				alert(data.resultMessage);
			}
		});
	}
	
	function doSearchYoutube() {
		var sUrl = "<c:url value='/admin/getYoutube.do'/>";
		var sParams = "";
		
		sParams += String.format("coDiv={0}", "65");
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			progressStop();
			
			if(data.resultCode = "0000") {
				var bucket = "hills";
				
				var rows = data.rows.list2;
				
				if(rows.length > 0) {		
					$(".movieBn").show();
					
					var fileName = rows[0].HP_FILE_NAME;    
					var originName = rows[0].HP_ORIGIN_FILE_NAME;			
					var link = rows[0].HP_LINK;			
					var image = String.format("<c:url value='/common/downloadImage.do?division={0}&folderName=youtube&fileName={1}'/>", bucket, fileName);
					
					$("#btnYoutube").append("<img src='" + image + "'>");
					$("#btnYoutube").attr("href", link);
				}
			} else {
				alert(data.resultMessage);
			}
		});
	}
	
	function doSearchBenner() {
		var sUrl = "<c:url value='/admin/getBenner.do'/>";
		var sParams = "";
		
		sParams += String.format("coDiv={0}", "65");
		
		progressStart();
		
		mAjax(sUrl, sParams, function(data) {
			progressStop();
			
			if(data.resultCode = "0000") { 
				var bucket = "hills";
				 
				var mBenner = data.rows.mobile;
				
				var slideContainer = $("#slideContainer");
				
				slideContainer.empty();
				
				var wrapper = $("<div class='bx-wrapper'></div>")
				
				var slider = $("<ul class='slider'></ul>");
				
				for(i=0; i<mBenner.length; i++) {
					var fileName = mBenner[i].HP_FILE_NAME;
					var fileLink = mBenner[i].HP_LINK; 
					
					fileLink = fileLink == "" ? "javascript:void(0)" : fileLink;
					
					var image = String.format("<c:url value='/common/downloadImage.do?division={0}&folderName=benner&fileName={1}'/>", bucket, fileName);
					
					slider.append(String.format("<li><a href='{0}'><img src='{1}'/></a></li>", fileLink, image));
				}
				
				wrapper.append(slider).appendTo(slideContainer);
				
				if(mBenner.length > 0) {
					$('.slider').bxSlider({
                        mode:'horizontal',
                        speed : 300,
                        pause : 3000,
                        auto: true,
                        controls: false,
                        pager:false     
                    });
				}
			} else {
				alert(data.resultMessage);
			}
		});
	}
	
	function initTable() {
		var $table = $("#time-table");
		var $header = $table.children("tbody").first().children("tr");
		
		$header.children("th").each(function(index, element) {
			var selector = "time-grid";
			var imgAsc = "<c:url value='/images/m_hills/t_arw.png'/>";
			var imgDesc = "<c:url value='/images/m_hills/t_arw1.png'/>";
			
			if(index == 0 || index == 5) {
				var type = index == 5 ? "n" : "s";
				
				$(this).css("background-image", "url(" + imgAsc + "), url(" + imgDesc + ")");
				$(this).css("background-position", "50% 10%, 50% 90%");
				$(this).css("background-size", "12px 7px, 12px 7px");
				$(this).css("background-repeat", "no-repeat");
				
				$(this).data("order", "asc");
				
				$(this).on("click", function() {
					sortTable(selector, type, $(this).data("order"), index);
					if($(this).data("order") == "asc") {
						$(this).css("background-image", "url(" + imgAsc + ")");
						$(this).css("background-position", "50% 10%");
						$(this).data("order", "desc");
					} else {
						$(this).css("background-image", "url(" + imgDesc + ")");
						$(this).css("background-position", "50% 90%");
						$(this).data("order", "asc");
					}
					$(this).css("background-size", "12px 7px");
				});
			}
		});
	}
	
	function init() {
		var date = new Date();
		var date2 = addMonth(date.yyyymmdd(), 1);

		initCalendar("#mainCalendar1", date.yyyy(), date.mm());
		initCalendar("#mainCalendar2", date2.yyyy(), date2.mm());
		
		var msId = "<c:out value='${sessionScope.msMember.msId}'/>";		
		if(msId == "") {
			$(".coupon_pop").hide();
		} else {
			$(".coupon_pop").show();			
		}
		
		$("#reservationContainer").hide();
	}
	
	function initCalendar(selector, year, month) {
		var sUrl = "<c:url value='/hills/reservation/getCalendar.do'/>";
		var sParams = "";

		sParams += String.format("&selYM={0}", year + month);	
		
		mAjax(sUrl, sParams, function(data) {			
			if(data.resultCode == "0000") {
				$(selector + " #calHeader").html(String.format("{0}??? {1}???", year, month));
				
				var currentDay = new Date().yyyymmdd();
				var tBody = $(selector + " #calendar-body");				
				tBody.empty();
				
				var rows = data.rows;
				var row = $("<tr></tr>");
				
				var fWeek = rows[0].CL_DAYDIV - 1;
				
				for(i=0; i<fWeek; i++) {
					row.append($("<td class='none'></td>"));
				}		
				
				var blank = 0;
				var blankFlag = true;
				
				for(i=0; i<rows.length; i++) {
					var td;
					
					if(rows[i].CL_BUSINESS != 5) {
						if(rows[i].CL_SOLAR <= currentDay) {
							if(rows[i].BK_TEAM > 0) {
								td = $("<td><a href='javascript:onClickDay(" + rows[i].CL_SOLAR + ")' class='MReser'>" + rows[i].DAYNUM + "<span>" + rows[i].BK_TEAM + "???</span></a></td>");
							} else {
								td = $("<td class='block'><a>" + rows[i].DAYNUM + "<span>??????</span></a></td>");
							}
						} else if(rows[i].CL_SOLAR > currentDay) {
							blankFlag = false;
							if(rows[i].BK_TEAM > 0) {
								td = $("<td><a href='javascript:onClickDay(" + rows[i].CL_SOLAR + ")' class='MReser'>" + rows[i].DAYNUM + "<span>" + rows[i].BK_TEAM + "???</span></a></td>");
							} else {
								if(rows[i].BK_TEAM_ALL == 0) {
									td = $("<td><a href='javascript:void(0)' class='MReser'>" + rows[i].DAYNUM + "<span style='color:#D5D5D5'>?????????</span></a></td>");
								} else {
									td = $("<td><a href='javascript:void(0)' class='MReser'>" + rows[i].DAYNUM + "<span style='color:red'>??????</span></a></td>");
								}
							}
						} 
						
						if(Number(rows[i].ROYAL_CNT) > 0) {
							if(rows[i].BK_TEAM == 0) {
								td = $("<td><a href='<c:url value='/m_hills/myzone/royaltime.do?date=" + rows[i].CL_SOLAR + "'/>' class='MReser'>" + rows[i].DAYNUM + "<span>" + rows[i].ROYAL_CNT + "???</span></a></td>");
								td.addClass('pink2');//??????
							} 
							
						}
						if(Number(rows[i].EARLY_CNT) > 0 ) {
							td.addClass('early');//??????   
						} else if(rows[i].MATCH_YN == 'Y') {
							td.addClass('pink');//??????
						} else if(Number(rows[i].SALE_COST_YN) > 0 ) {
							td.addClass('green');//??????
						}
					} else {
						td = $("<td><a href='javascript:void(0)' class='MReser'>" + rows[i].DAYNUM + "<span style='color:#D5D5D5'>??????</span></a></td>");
					}
					
					if(rows[i].CL_BUSINESS == 2) {
						td.children('a').addClass('blue');
					} else if(rows[i].CL_BUSINESS == 3 || rows[i].CL_BUSINESS == 4) {
						td.children('a').addClass('red');
					}
					
					row.append(td);
					
					blank += 1;
										
					if(rows[i].CL_DAYDIV == 7) {
						if(!blankFlag) {
							row.appendTo(tBody); 
							blankFlag = true;							
						}
						row = $("<tr></tr>");
						blank = 0;
					}					
				}	
				
				for(i=0; i<7-blank; i++) {
					row.append($("<td class='none'></td>"));
				}	
				
				if(currentDay == rows[rows.length - 1].CL_SOLAR) {
					blankFlag = false;
				}

				if(!blankFlag) {
					row.appendTo(tBody); 
				}
			} else {
				alert(data.resultMessage);	
			}
		});	
	}
	
	function onClickDay(date) {
		mDate = date.toString();
		 
		if(!isReserOpen) {
			$("#reservationContainer").show(); 
		}
		
		doSearch();
	}
	
	function onCosTapChange(cos) {
		if(cos == '') {
			$(".MCourse_Tab #cosAll").addClass("on");
			$(".MCourse_Tab #cosA").removeClass("on");
			$(".MCourse_Tab #cosB").removeClass("on");
			$(".MCourse_Tab #cosC").removeClass("on");
		} else if(cos == 'A') {
			$(".MCourse_Tab #cosAll").removeClass("on");
			$(".MCourse_Tab #cosA").addClass("on");
			$(".MCourse_Tab #cosB").removeClass("on");
			$(".MCourse_Tab #cosC").removeClass("on");			
		} else if(cos == 'B') {
			$(".MCourse_Tab #cosAll").removeClass("on");
			$(".MCourse_Tab #cosA").removeClass("on");
			$(".MCourse_Tab #cosB").addClass("on");
			$(".MCourse_Tab #cosC").removeClass("on");
		} else if(cos == 'C') {
			$(".MCourse_Tab #cosAll").removeClass("on");
			$(".MCourse_Tab #cosA").removeClass("on");
			$(".MCourse_Tab #cosB").removeClass("on");	
			$(".MCourse_Tab #cosC").addClass("on");
		}
		
		mCos = cos;
		doSearch(); 
	}
	
	function onPartTapChange(part) {
		if(part == '') {
			$(".Mtable_Tab #partAll").addClass("on1");
			$(".Mtable_Tab #part1").removeClass("on1");
			$(".Mtable_Tab #part2").removeClass("on1");
			$(".Mtable_Tab #part3").removeClass("on1");
		} else if(part == '1') {
			$(".Mtable_Tab #partAll").removeClass("on1");
			$(".Mtable_Tab #part1").addClass("on1");
			$(".Mtable_Tab #part2").removeClass("on1");
			$(".Mtable_Tab #part3").removeClass("on1");
		} else if(part == '2') {
			$(".Mtable_Tab #partAll").removeClass("on1");
			$(".Mtable_Tab #part1").removeClass("on1");
			$(".Mtable_Tab #part2").addClass("on1");
			$(".Mtable_Tab #part3").removeClass("on1");
		} else if(part == '3') {
			$(".Mtable_Tab #partAll").removeClass("on1");
			$(".Mtable_Tab #part1").removeClass("on1");
			$(".Mtable_Tab #part2").removeClass("on1");
			$(".Mtable_Tab #part3").addClass("on1");
		}
		
		mPart = part;              
		doSearch(); 
	}
	
	function doSearch() {			
		if(mDate == null || mDate == '') {
			alert("????????? ???????????????.");
			return;
		}
		
		var date = new Date(mDate.substring(0, 4) + "-" + mDate.substring(4, 6) + "-" + mDate.substring(6, 8));
		$("#mainReserveDate").html(String.format("{0}??? {1}??? {2}??? &#40;{3}??????&#41;", date.yyyy(), date.mm(), date.dd(), date.week()));
		
		var sUrl = "<c:url value='/hills/reservation/getTeeList.do'/>";
		var sParams = "";
		
		sParams += String.format("&date={0}", mDate);
		
		if(mCos != null && mCos != "") {
			sParams += String.format("&cos={0}", mCos);
		}
		
		if(mPart != null && mPart != "") {
			sParams += String.format("&part={0}", mPart);
		}
		
		progressStart2();
		
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
					var row = $("<tr onclick='onClickReservationRow(" + i + ")'></tr>"); 
					
					var bkTime = rowData[i].BK_TIME;
					bkTime = (Number(bkTime) < 1200 ? "??????" : "??????") + " " + bkTime.substring(0, 2) + ":" + bkTime.substring(2, 4);
					var bkCharge;
					if(rowData[i].BK_CHARGE != null && rowData[i].BK_CHARGE != ""){
						bkCharge = rowData[i].BK_CHARGE.split(",")	
					}
					var proDcGu = rowData[i].PRO_DC_GU;
					var proDcVal = rowData[i].PRO_DC_VALUE;				    
				    var bkChargeNm = bkCharge[1];
				    var rGu = rowData[i].R_GU;
					
				    var col1 = $("<td>" + bkTime + "<br>" + rowData[i].BK_COS_NM + "</td>");
				    var col2 = $("<td>" + rowData[i].BK_ROUNDF_NM + "</td>");				    
				    var col3 = $("<td>" + globals.personCd.codeNm(rowData[i].BK_PERSON_CD) + "</td>");
				    var col4 = $("<td>" + numberWithCommas(rowData[i].BK_BASIC_CHARGE) + "</td>");			
				    var col5;
				    if(bkCharge[2] == "M") {
				    	col5 = $("<td><span class='event_ss'>??????</span></td>");
					    col4.css("text-decoration", "line-through");
				    } else if(bkCharge[2] == "S") {
				    	if(rowData[i].MN_COST_YN == "Y") {
				    		col4 = $("<td>" + numberWithCommas(bkCharge[1]) + "</td>");	
				    		col5 = $("<td></td>");
				    	} else {
						    col4.css("text-decoration", "line-through");
						    col5 = $("<td><span class='event_ss'>??????</span></td>");
				    	}
				    } else if(bkCharge[2] == "R") {
				    	col5 = $("<td><span class='event_ss'>??????</span></td>");
					    col4.css("text-decoration", "line-through");
				    } else {
				    	col5 = $("<td></td>");
				    }
				    
				    if(rGu != "X") {
				    	if(rGu == "1") {
				    		col5 = $("<td><span class='event_sr'>??????</span></td>"); 
				    		row = $("<tr onclick='royalPopupOpen(rowData[" + i + "])'></tr>");
				    	} else if(rGu == "2") {
				    		col5 = $("<td><span class='event_se'>??????</span></td>");
				    	} 
				    	else if(rGu == "3") {
				    		col5 = $("<td><span class='event_sf'>??????</span></td>");		
				    	}				    	
					    col4.css("text-decoration", "line-through");
					    
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
				    			if(sTag.length > 2) sTag += "<br>+<br>??????";
				    			else sTag += "+??????";
				    		}
				    		
					    	col5 = $("<td><span class='event_sc'>" + sTag + "</span></td>");
						    col4.css("text-decoration", "line-through");
				    	} else {
				    		bkChargeNm = defaultCharge;
				    	}
				    }
				    
				    var amtGu = rowData[i].R_AMT_GU == "1" && rGu == "1" ? "<span class='icon_team'>???</span>" : "";
				    
				    var col6 = $("<td class='last'>" + amtGu + numberWithCommas(bkChargeNm) + "</td>");				    
				    
				    row.append(col1,col2,col3,col4,col5,col6).appendTo(tBody); 
				}
				
				var offset = $(".Mtable_Tab").offset();
		        $('html, body').animate({scrollTop : offset.top}, 400);
			}
			
			progressStop();
		});
	}
	
	function onClickReservationRow(i) {		
		if(rowData[i].BK_DAY == new Date().yyyymmdd()) {
			alert("??????????????? ???????????? ?????? ??????????????????.");
			return;
		}
		
		confirmPopupOpen("I", rowData[i], null);
	}

</script>  

<link rel="stylesheet" type="text/css" href="<c:url value='/css/m_hills/main.css?ver=2'/>">

	<div class="introPop1" id="pop1" hidden>
      <div class="bx-wrapper1">
        <ul class="slider1">
        </ul>
      </div>
      <div class="closeBox">
      	<div class="todayClose" onclick="setCookie('mobileMainPopup', 'Y', 1); $('#pop1').hide();">???????????? ????????? </div>
      	<div class="introPopClose" onclick="$('#pop1').hide()">??????</div>
      </div>
    </div>
    
<div id="mWrap">
    <div class="Mcontent">
        <!--??????????????????-->
        <div class="photoSlider" id="slideContainer">
        </div>
        <!--//??????????????????-->
        
        <!-- ?????????????????? -->
        <div class="Mtab_btn">
        	<a href="<c:url value='/m_hills/board/list.do?bbsType=1'/>">????????????</a>
        	<a href="<c:url value='/m_hills/board/list.do?bbsType=6'/>">?????????</a>
        	<a href="<c:url value='/m_hills/course/courseIntro.do'/>">??????</a>
        	<a href="tel:031-940-9400"><img src="<c:url value='/images/m_hills/main/icon_phone.jpg'/>"></a>   
        </div>
        <!-- //?????????????????? -->
        
        <!--???????????????-->
        <div class="mCalendar">
            <!--???????????????-->
            <div class="CalendarBox" id="mainCalendar1">
            <h2 id="calHeader"></h2>
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
                        <th scope="col">SUN</th>
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
						<tr><td colspan="7"><div></div></td></tr>
                    </tbody>
                </table>
                <p><span style="color:#ff9b0d">&#9679;</span> ??????????????? <span style="color:#96ab0d">&#9679;</span> ?????? <span style="color:#bc32da">&#9679;</span> ???????????? <span style="color:#c89f23">&#9679;</span> ????????????</p>
            </div>            
            <!--???????????????-->
            <div class="CalendarBox" id="mainCalendar2">
            <h2 id="calHeader"></h2>
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
                        <th scope="col">SUN</th>
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
						<tr><td colspan="7"><div></div></td></tr>
					</tbody>
                </table>
            	<p><span style="color:#ff9b0d">&#9679;</span> ??????????????? <span style="color:#96ab0d">&#9679;</span> ?????? <span style="color:#bc32da">&#9679;</span> ???????????? <span style="color:#c89f23">&#9679;</span> ????????????</p>
            </div> 
        </div>
        <!--//???????????????-->

        <!--??????contents-->
        <div class="MReser_Wrap" id="reservationContainer">
            <h2><span class="Rright_arw"></span> ????????????</h2>
            <p>&bull; ???????????? : <span id="mainReserveDate"></span></p>
            
            <!--????????????-->
			<div class="CTab1">
				<div class="MCourse_Tab">
					<ul>
						<li class="on" onclick="onCosTapChange('')" id="cosAll">????????????</li>
						<li onclick="onCosTapChange('A')" id="cosA">???????????????</li>
						<li onclick="onCosTapChange('B')" id="cosB">???????????????</li>
						<li onclick="onCosTapChange('C')" id="cosC">???????????????</li>
					</ul>
					
					<!-- <div class="earlyBox">
				    	<span class="event_sf">???</span>???????????? &nbsp;&nbsp;
						<span class="event_se">???</span>???????????? &nbsp;&nbsp;
						<span class="event_sc">???</span>?????? &nbsp;&nbsp;
						<span class="event_ss">???</span>??????                
				    </div> -->
					
					<div class="TTab1">
						<div class="Mtable_Tab">
							<ul>
								<li class="on1" onclick="onPartTapChange('')" id="partAll">??????</li>
								<li onclick="onPartTapChange('1')" id="part1">1???</li>
								<li onclick="onPartTapChange('2')" id="part2">2???</li>
								<li onclick="onPartTapChange('3')" id="part3">3???</li>
							</ul>
							<div>
								<table class="MainTable" id="time-table">
									<caption>????????????</caption>
									<colgroup>
										<col width="20%">
										<col width="8%">
										<col width="12%">
										<col width="*">
										<col width="*">
										<col width="*">
									</colgroup>
									<tr>
										<th scope="col">??????</th>
										<th scope="col">???</th>
										<th scope="col">??????</th>
										<th scope="col">??????????????????</th>
										<th scope="col">?????????</th>
										<th scope="col">???????????????</th>
									</tr>
									<tbody id="time-grid">
									</tbody>
									<tr>
										<td colspan="6" class="td_merge"><span>??? ?????? ????????? ???????????? ???????????? ????????? ????????? ?????? ???????????????.</span></td>
									</tr>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
        <!--//??????contents-->
    </div>
    
    <!--????????????-->
    <div class="coupon_pop">
        <a href="<c:url value='/m_hills/member/coupon.do'/>"><img src="<c:url value='/images/m_hills/coupon_pop.png'/>"></a>
        <img src="<c:url value='/images/m_hills/pop_x.gif'/>" onclick="$('.coupon_pop').hide()" class="pop_x">
        <h2><a id="imgIndexCouponCount">0???</a></h2>
    </div>
    
    <!--????????????-->
    <div class="movieBn" hidden>
        <a href="" id="btnYoutube"></a>
        <img src="<c:url value='/images/m_hills/pop_x.gif'/>" onclick="$('.movieBn').hide()" class="movieBn_x">
    </div>
   
<jsp:include page="../m_hills/include/footer.jsp" flush="true" />
</div>   

</body>
</html>



