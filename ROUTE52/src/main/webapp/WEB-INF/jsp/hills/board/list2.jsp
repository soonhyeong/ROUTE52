<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="../include/header.jsp" />
<jsp:include page="../include/subTop.jsp" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/hills/animate.css'/>">
<script src="<c:url value='/js/hills/wow.js'/>"></script>
<script type="text/javascript">

	var rowData;
	var startPage = 1;
	var endPage = 1;
	var currentPage = 1;
	var oOption = "";
	var oText = "";
	
	$(document).ready(function() { 
		doSearch(); 

	    var offset = $(".myzoneTabList3").offset();
	    $('html, body').animate({scrollTop : offset.top}, 400);
	});
	
	function doSearch() {
		var gBody = $("#gBody");
		
		var sUrl = "<c:url value='/hills/board/getBoardData.do'/>";
		var sParams = "";
		
		var bbsType = "<c:out value='${bbsType}'/>";
		if (bbsType != "") {
			sParams += String.format("bbsType={0}", bbsType);
		} else {
			alert("알 수 없는 오류입니다. 다시 시도해주세요.");
		}	
		
		var nOption = $("#searchOption").val();
		var nText = $("#searchText").val();
		
		if(nOption != oOption || nText != oText) {
			startPage = 1;
			currentPage = 1;
			oOption = nOption;
			oText = nText;
		}
		
		sParams += String.format("&startCnt={0}", (currentPage - 1) * 12);	
		
		if(nOption != "") {
			sParams += String.format("&searchOption={0}", nOption);
		}
		
		if(nText != "") {
			sParams += String.format("&searchText={0}", nText);
			
			if(nOption == "") {
				alert("조회 옵션을 선택해주세요.");
				return;
			}
		}
		
		mAjax(sUrl, sParams, function(data) {
			if(data.resultCode == "0000") {
				gBody.empty();
				
				rowData = data.rows;
				
				if(rowData.length == 0) {
					return;
				}
				
				for(i=0; i<rowData.length; i++) {		
					if(rowData[i].IDX == "67") {
						continue;
					}
					
					
					var content = "";
					content += "<div class='galleryBox fadeBox fadeInUp'>                      ";
					content += "    <div class='gallBoxCont'>                                  ";
					content += "        <a href='{0}' class='galImg'><img src='{1}' alt=''></a>";
					content += "        <a href='{0}'> 										   ";
					content += "            <div class='gallery'>							   ";
					content += "                <div class='gallTitle'>{2}                     ";
					content += "                <span class='orangeRed'>{3}</span>             ";
					content += "                </div>                                         ";
					content += "                <p class='gallDate'>{4}</p>                    ";
					content += "                <span class='gallBtn'>자세히보기</span>           ";
					content += "            </div>                                             ";
					content += "        </a>                                                   ";
					content += "    </div>                                                     ";
					content += "</div>                                                         ";

					var href = "javascript:onClickRow(" + i + ")";
					var imageUrl = rowData[i].UP_FILENAME;
					var title = rowData[i].TITLE;
					var replyCnt = rowData[i].REPLY_CNT;
					var regDate = rowData[i].REGDATE;
					var folderName = rowData[i].FOLDER_NAME;
					
					if(imageUrl != "") {
						imageUrl = "<c:url value='/common/downloadImage.do?division=hills&folderName=" + folderName + "&fileName=" + imageUrl + "'/>";
					} else {
						imageUrl = "<c:url value='/images/hills/boardDefaultImage.jpg'/>";
					}
					
					replyCnt = replyCnt == "0" ? "" : String.format("({0})", replyCnt);
					
					content = String.format(content, href, imageUrl, title, replyCnt, regDate);

					gBody.append(content);
				}
				
				initPaging(rowData[0].TOTAL_CNT);
	
			} else {
				alert(data.resultMessage);	
			}
		});
	}
	
	function doSearchPaging(page) {
		currentPage = page;
		doSearch();
	}
	
	function doSearchPaging(page) {
		currentPage = page;
		doSearch();
	}
	
	function doSearchPaging10(page) {
		currentPage = page;
		startPage = page;
		doSearch();
	}
	
	function initPaging(totalCnt) {
		var pageContainer = $("#paging ul");
		pageContainer.empty();
		var page = startPage;
		var prevBtn = "<li onclick='doSearchPaging10(" + (startPage - 10) + ")'><img src='<c:url value='/images/hills/prev.png'/>' alt=''></li>";
		var nextBtn = "<li onclick='doSearchPaging10(" + (startPage + 10) + ")'><img src='<c:url value='/images/hills/next.png'/>' alt=''></li>";
		
		if(startPage != 1){
			pageContainer.append(prevBtn);
		}
		
		endPage = Math.floor(totalCnt / 12);
		if(totalCnt % 12 != 0) {
			endPage += 1;
		}
		
		for(i=startPage; i<startPage+10; i++) {
			if(i > endPage) break;
			
			var li;
			
			if(currentPage == page) {
				li = String.format("<li class='on' onclick='doSearchPaging({0})'>{0}</li>", page);
			} else {
				li = String.format("<li onclick='doSearchPaging({0})'>{0}</li>", page);
			}
			
			pageContainer.append(li);
			page += 1;
		}
		
		if(endPage - startPage >= 10) {
			pageContainer.append(nextBtn);
		}		
	}
	
	function onClickRow(i) {
		var sUrl = "<c:url value='/hills/board/view.do'/>";
		var sParams = "";
		
		sParams += "?bbsType=<c:out value='${bbsType}'/>";
		sParams += "&idx=" + rowData[i].IDX;
		
		location.href = sUrl + sParams;
	}

	/* 컨텐츠 fade in */
	wow = new WOW(
	{
		boxClass: 'fadeBox',
		animateClass: 'animated',
		offset: 100,
		callback: function(box) {
			//console.log("WOW: animating <" + box.tagName.toLowerCase() + ">")
		}
	});
	wow.init();
	/*//컨텐츠 fade in */
</script>

<div class="lnbBox">
	<div class="lnb">
		<img src="<c:url value='/images/hills/ico-home.png'/>" alt="">
		<c:if test="${bbsType eq '51'}">
			<p>제휴안내 &nbsp;&nbsp;&nbsp; ＞ <span>전체보기</span></p>
		</c:if>
		<c:if test="${bbsType eq '52'}">
			<p>제휴안내 &nbsp;&nbsp;&nbsp; ＞ <span>골프용품(의류)</span></p>
		</c:if>
		<c:if test="${bbsType eq '53'}">
			<p>제휴안내 &nbsp;&nbsp;&nbsp; ＞ <span>호텔/레저/외식</span></p>
		</c:if>
		<c:if test="${bbsType eq '54'}">
			<p>제휴안내 &nbsp;&nbsp;&nbsp; ＞ <span>기타</span></p>
		</c:if>
	</div>
</div>

<div id="wrap">
	<div class="contents">
		<div class="myzoneTabList5">
				<a href="<c:url value='/hills/board/jhqna.do'/>" class="">제휴안내</a>
			<c:if test="${bbsType eq '51'}">
				<a href="<c:url value='/hills/board/list.do?bbsType=51'/>" class="on">전체보기</a>
			</c:if>
			<c:if test="${bbsType ne '51'}">
				<a href="<c:url value='/hills/board/list.do?bbsType=51'/>">전체보기</a>
			</c:if>
			<c:if test="${bbsType eq '52'}">
			<a href="<c:url value='/hills/board/list.do?bbsType=52'/>" class="on">골프용품(의류)</a>
			</c:if>
			<c:if test="${bbsType ne '52'}">
			<a href="<c:url value='/hills/board/list.do?bbsType=52'/>">골프용품(의류)</a>
			</c:if>
			<c:if test="${bbsType eq '53'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=53'/>" class="on">호텔/레저/외식</a>
			</c:if>
			<c:if test="${bbsType ne '53'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=53'/>">호텔/레저/외식</a>
			</c:if>				
			<c:if test="${bbsType eq '54'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=54'/>" class="on">기타</a>
			</c:if>
			<c:if test="${bbsType ne '54'}">		
			<a href="<c:url value='/hills/board/list.do?bbsType=54'/>">기타</a>
			</c:if>				
		</div>
		<div class="subTitle subBottom">
			<c:if test="${bbsType eq '51'}">
				<span class="title">전체보기</span>
			</c:if>
			<c:if test="${bbsType eq '52'}">
				<span class="title">골프용품(의류)</span>
			</c:if>
			<c:if test="${bbsType eq '53'}">
				<span class="title">호텔/레저/외식</span>
			</c:if>
			<c:if test="${bbsType eq '54'}">
				<span class="title">기타</span>
			</c:if>
			<span class="titleDes"></span>
		</div>
		<div class="listBox">
			<div class="findBox">
				<select name="" id="searchOption" class="select-arrow">
					<option value="">전체</option>
					<option value="1">제목</option>
					<option value="2">내용</option>
					<option value="3">작성자</option>
				</select>
				<input type="text" class="findTxt" id="searchText">
				<a href="javascript:doSearch()" class="orangeBtn">검색</a>
			</div>

			<div class="galleryListBox" id="gBody"></div>
		</div>	
						
		<div class="paging" id="paging"><ul></ul></div>		
		<c:if test="${sessionScope.msMember.webAdmin == 'Y'}">
			<div class="btnBox">
				<a href="<c:url value='/hills/board/write.do?bbsType=${bbsType}'/>" class="orangeBtn">글쓰기</a>
			</div>
		</c:if>
	</div><!-- contents End -->
</div>

<jsp:include page="../include/footer-quick.jsp" flush="true" />
<jsp:include page="../include/footer.jsp" flush="true" />