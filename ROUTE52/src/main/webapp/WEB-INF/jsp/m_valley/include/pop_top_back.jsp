<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<link rel="stylesheet" type="text/css" href="<c:url value='/css/m_valley/pop_top.css'/>">  
<script>
    var MopenIdx = -1;
    
    function MpopupOpen(i) {
        MinitPopup(i);
    }

    function MinitPopup(i) {
        var fW = $(window).width() / 2;
        var fH = $(window).height() / 2;
        var cW = Number($("#topArea" + i).css("width").replace("px", "")) / 2;
        var cH = Number($("#topArea" + i).css("height").replace("px", "")) / 2;
        var mW = fW - cW;
        var mH = fH - cH;

        $("#topArea" + i).css("left", mW);
        $("#topArea" + i).css("top", mH);

        $("#topArea" + i).css("display", "block");
        $("#overlay1").css("display", "block");

		MopenIdx = i;
    }

    function MpopupClose(i) {
		if(i == 1) {
			$("#topArea" + i).css("display", "none");
			$("#overlay1").css("display", "none");
		} else {
			$("#topArea1").css("display", "none");
			$("#topArea2").css("display", "none");
			$("#overlay1").css("display", "none");
		}        
    }

    function MpopupOverlayClicked() {
		if(MopenIdx == 1) {
			$("#topArea" + i).css("display", "none");
			$("#overlay1").css("display", "none");
		} else {
			$("#topArea1").css("display", "none");
			$("#topArea2").css("display", "none");
			$("#overlay1").css("display", "none");
		} 
    }

    function MpopupBeforeStep(i) {
		$("#topArea" + i).css("display", "none");
		$("#overlay1").css("display", "none");
    }
    
    function clickTab(gubun) {
		if (gubun == "1") {
			$("#Tab1").attr("style",'display:block'); 
			$("#Tab2").attr("style",'display:none'); 
			$("#Tab3").attr("style",'display:none'); 
		} else if (gubun == "2") {
			$("#Tab1").attr("style",'display:none'); 
			$("#Tab2").attr("style",'display:block'); 
			$("#Tab3").attr("style",'display:none'); 
		} else if (gubun == "3") {
			$("#Tab1").attr("style",'display:none'); 
			$("#Tab2").attr("style",'display:none'); 
			$("#Tab3").attr("style",'display:block'); 
		}
	}
</script>

<div id="topArea1" class="searchBox1">
    <div class="choiceBox">
        <span class="title">????????????</span>
        <span class="reserSelect">
            <select name="" id="" class="selcetBox">
                <option value="">????????????</option>
                <option value=""></option>
            </select>
        </span>	
    </div>
    <div class="choiceBox">
        <span class="title">????????????</span>
        <img src="<c:url value='/images/m_valley/modalcal.jpg'/>" alt="??????" class="small_cal">
        <!--??????????????????-->
        <div class="dayInput" id="show_hideSub5"></div>				
       	<div class="SubMonthBox5">
      		<div class="monthChoice1">
                    <span class="arw"><a href=""><img src="<c:url value='/images/m_valley/arrow_l.png'/>" alt="??? ???" ></a></span>
                    <span class="month">2019/2/10</span>
                    <span class="arw"><a href=""><img src="<c:url value='/images/m_valley/arrow_r.png'/>" alt="?????????"></a></span>
                 </div>

            <table class="mainCalendar1" summary="????????? ??????" cellspacing="5">
                     <caption>????????? ??????</caption>
                    <colgroup>
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="col" class="sun">SUN</th>
                        <th scope="col">MON</th>
                        <th scope="col">TUE</th>
                        <th scope="col">WEN</th>
                        <th scope="col">THU</th>
                        <th scope="col">FRI</th>
                        <th scope="col">SAT</th>
                      </tr>
                      <tr>
                        <td><div></div></td>
                        <td><div></div></td>
                        <td><div>1</div></td>
                        <td><div>2</div></td>
                        <td><div>3</div></td>
                        <td><div>4</div></td>
                        <td><div>5</div></td>
                      </tr>
                      <tr>
                        <td><div>6</div></td>
                        <td><div>7</div></td>
                        <td><div>8</div></td>
                        <td><div>9</div></td>
                        <td><div>10</div></td>
                        <td><div>11</div></td>
                        <td><div>12</div></td>
                      </tr>
                      <tr>
                        <td><div>13</div></td>
                        <td><div>14</div></td>
                        <td class="today possible"><div>15</div></td>
                        <td class="possible"><div>16</div></td>
                        <td class="possible"><div>17</div></td>
                        <td class="possible"><div>18</div></td>
                        <td class="possible"><div>19</div></td>
                      </tr>
                      <tr>
                        <td><div>20</div></td>
                        <td><div>21</div></td>
                        <td class="possible"><div>22</div></td>
                        <td class="possible"><div>23</div></td>
                        <td class="possible"><div>24</div></td>
                        <td class="possible"><div>25</div></td>
                        <td class="possible"><div>26</div></td>
                      </tr>
                      <tr>
                        <td class="possible"><div>27</div></td>
                        <td class="possible"><div>28</div></td>
                        <td class="possible"><div>29</div></td>
                        <td class="possible"><div>30</div></td>
                        <td class="possible"><div>31</div></td>
                        <td><div></div></td>
                        <td><div></div></td>
                      </tr>
                    </tbody>
                </table>
            
        </div><!--//???????????? ???--> 
        <span>&nbsp; ~ &nbsp;</span>
        <img src="<c:url value='/images/m_valley/modalcal.jpg'/>" alt="??????" class="small_cal">
        <!--??????????????????-->
        <div class="dayInput" id="show_hideSub6"></div>					
            <div class="SubMonthBox6">
                <div class="monthChoice1">
                    <span class="arw"><a href=""><img src="<c:url value='/images/m_valley/arrow_l.png'/>" alt="??? ???" width="15" height="20"></a></span>
                    <span class="month">2019/2/10</span>
                    <span class="arw"><a href=""><img src="<c:url value='/images/m_valley/arrow_r.png'/>" alt="?????????" width="15" height="20"></a></span>
                  </div>

                <table class="mainCalendar1" summary="????????? ??????" cellspacing="5">
                    <caption>????????? ??????</caption>
                    <colgroup>
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">
                        <col width="*">

                    </colgroup>
                    <tbody>
                      <tr>
                        <th scope="col" class="sun">SUN</th>
                        <th scope="col">MON</th>
                        <th scope="col">TUE</th>
                        <th scope="col">WEN</th>
                        <th scope="col">THU</th>
                        <th scope="col">FRI</th>
                        <th scope="col">SAT</th>
                      </tr>
                      <tr>
                        <td><div></div></td>
                        <td><div></div></td>
                        <td><div>1</div></td>
                        <td><div>2</div></td>
                        <td><div>3</div></td>
                        <td><div>4</div></td>
                        <td><div>5</div></td>
                      </tr>
                      <tr>
                        <td><div>6</div></td>
                        <td><div>7</div></td>
                        <td><div>8</div></td>
                        <td><div>9</div></td>
                        <td><div>10</div></td>
                        <td><div>11</div></td>
                        <td><div>12</div></td>
                      </tr>
                      <tr>
                        <td><div>13</div></td>
                        <td><div>14</div></td>
                        <td class="today possible"><div>15</div></td>
                        <td class="possible"><div>16</div></td>
                        <td class="possible"><div>17</div></td>
                        <td class="possible"><div>18</div></td>
                        <td class="possible"><div>19</div></td>
                      </tr>
                      <tr>
                        <td><div>20</div></td>
                        <td><div>21</div></td>
                        <td class="possible"><div>22</div></td>
                        <td class="possible"><div>23</div></td>
                        <td class="possible"><div>24</div></td>
                        <td class="possible"><div>25</div></td>
                        <td class="possible"><div>26</div></td>
                      </tr>
                      <tr>
                        <td class="possible"><div>27</div></td>
                        <td class="possible"><div>28</div></td>
                        <td class="possible"><div>29</div></td>
                        <td class="possible"><div>30</div></td>
                        <td class="possible"><div>31</div></td>
                        <td><div></div></td>
                        <td><div></div></td>
                      </tr>
                    </tbody>
                </table>
            </div>
        </div><!--//???????????? ???--> 
    <div class="choiceBox">
        <span class="title">?????????&nbsp;&nbsp;&nbsp;</span>
        <span class="reserTime">
            <select name="" id="">
                <option value="">12???</option>
                <option value=""></option>
            </select>
            <select name="" id="">
                <option value="">12???</option>
                <option value=""></option>
            </select>
        </span>	
    </div>
    <!--???????????????-->
    <div class="choiceBox">
        ????????? ??????
    </div>
    <!--//???????????????-->
    <div class="dotLine2"></div>
    <div class="btnBox2">
        <li><input type="button" class="motion1" onclick="MpopupOpen(2)" value="??? ???"/> </li>
        <li><input type="button" class="cancel" onclick="javascript:MpopupClose(1)" value="??? ???"  /></li>
    </div>
</div>
<div id="topArea2" class="searchBox2">
    <h2> &bull; ???????????? &bull;</h2>
    <div class="searchWrap">
        <!--?????????-->
        <div class="tLTab">
            <ul>
                <li class="orange" onclick="javascript:clickTab('1');">?????????</li>
                <li class="deepGray" onclick="javascript:clickTab('2');">?????????</li>
                <li class="gray"onclick="javascript:clickTab('3');">????????????</li>
            </ul>
        </div>
        <!--???????????????-->
        <div class="tLContents" id="Tab1">
            <div class="tLWrap">
                <!--???????????????-->
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <!--//???????????????-->
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">2019.01.31(???)<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (09 : 30)<span class="price">160,000???</span></p>
                    </a>
                </div>
            </div>
            <!--??????-->
            <div class="btnBox3">
                <li><input type="button" class="motion1" onclick="javascript:MpopupBeforeStep(2)" value="?????????"/> </li>
                <li><input type="button" class="cancel" onclick="javascript:MpopupClose(2)" value="??????"  /></li>
            </div>
            <!--//??????-->
        </div>
        <!--//???????????????-->
        
        <!--???????????????-->
        <div class="tLContents" id="Tab2">
            <div class="tLWrap">
                <!--???????????????-->
                <div class="tLList">
                    <a href="">
                    <p class="day">13 : 00 ~ 18 : 00<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (19.01.31 ?????????)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <!--//???????????????-->
                <div class="tLList">
                    <a href="">
                    <p class="day">13 : 00 ~ 18 : 00<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (19.01.31 ?????????)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">13 : 00 ~ 18 : 00<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (19.01.31 ?????????)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">13 : 00 ~ 18 : 00<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (19.01.31 ?????????)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">13 : 00 ~ 18 : 00<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (19.01.31 ?????????)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <div class="tLList">
                    <a href="">
                    <p class="day">13 : 00 ~ 18 : 00<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">EAST (19.01.31 ?????????)<span class="price">160,000???</span></p>
                    </a>
                </div>
            </div>
            <!--??????-->
            <div class="btnBox3">
                <li><input type="button" class="motion1" onclick="javascript:MpopupBeforeStep(2)" value="?????????"/> </li>
                <li><input type="button" class="cancel" onclick="javascript:MpopupClose(2)" value="??????"  /></li>
            </div>
            <!--//??????-->
        </div>
        <!--//???????????????-->
        
        <!--??????????????????-->
        <div class="tLContents" id="Tab3">
            <div class="tLWrap">
                <!--???????????????-->
                <div class="tLList">
                    <a href="">
                    <p class="day">160,000???<span class="all"><strong>37</strong>???</span></p>
                    <p class="time">19.01.31(???) EAST (09:30)<span class="price">160,000???</span></p>
                    </a>
                </div>
                <!--//???????????????-->
                
            </div>
            <!--??????-->
            <div class="btnBox3">
                <li><input type="button" class="motion1" onclick="javascript:MpopupBeforeStep(2)" value="?????????"/> </li>
                <li><input type="button" class="cancel" onclick="javascript:MpopupClose(2)" value="??????"  /></li>
            </div>
            <!--//??????-->
        </div>
        <!--//??????????????????-->
    </div>
</div>
<div id="overlay1" class="overlay" onclick="MpopupOverlayClicked()"></div>