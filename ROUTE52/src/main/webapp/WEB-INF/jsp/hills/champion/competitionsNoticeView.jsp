<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:if test="${bbsType eq '7' || bbsType eq '8'}">
<jsp:include page="../include/ct_header5.jsp" />
</c:if>
<c:if test="${bbsType eq '41' || bbsType eq '42'}">
<jsp:include page="../include/ct_header2.jsp" />
</c:if>
<c:if test="${bbsType eq '43' || bbsType eq '44'}">
<jsp:include page="../include/ct_header3.jsp" />
</c:if>
<c:if test="${bbsType eq '45' || bbsType eq '46'}">
<jsp:include page="../include/ct_header4.jsp" />
</c:if>

<script type="text/javascript">

	$(document).ready(function() { 
		initHeaderTab(5);
		
		var content = "${content}";
		
		content = convertSpecialCharacters(content);
		
		$("#txtContent").append(content);
		
		initImage();
		
		initAttachFiles();	
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

		if(file1 != "" || file2 != "") {
			$("#viewAttach").show();
		}
		
		if(file1 != "") {
			$("#attachFile1 a").append(file1);
			$("#attachFile1 a").click(function() {
				downloadAttachFile(folderName, file1, originFileName1);
			});
		}
		
		if(file2 != "") {
			if(file1 != ""){
				$("#attachFile2").prepend(" ,  ");
			}
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

</script>

<div id="wrap">
	<div class="contents">
		<div class="subTitle subBottom">
			<span class="title">????????????</span>
			<span class="titleDes"></span>
		</div>
		
		<div class="viewBox grayBgBox">
			<div class="viewTitleBox">
				<span class="viewTitle">${title}</span>
				<span class="viewDate">${regDate}</span>
			</div>		
			<img src="" id="viewMainImage" class="viewMainImage"  alt="">
			
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

<jsp:include page="../include/footer.jsp" flush="true" />