<%@page import="java.util.ArrayList"%>
<%@page import="vo.CommBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	ArrayList<CommBean> articleList = (ArrayList<CommBean>)request.getAttribute("articleList");
	CommBean article = (CommBean)request.getAttribute("article");
	String nowPage = request.getParameter("page");
	String member_id = (String)session.getAttribute("member_id");
	
	if(member_id == null){
		%>
		<script>
			alert("잘못된 접근입니다!");
			history.back();
		</script>
		<%
	}
%>

<jsp:include page="../inc/header.jsp"/>
<!-- QuickMenu -->
<jsp:include page="../quickMenu.jsp" />

	<!-- breadcrumb -->
	<div class="container">
		<div class="bread-crumb flex-w p-l-25 p-r-15 p-t-30 p-lr-0-lg">
			<a href="Main.go" class="stext-109 cl8 hov-cl1 trans-04">
				Home
				<i class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i>
			</a>
			<a href="CommList.co" class="stext-109 cl8 hov-cl1 trans-04">
				Community
				<i class="fa fa-angle-right m-l-9 m-r-10" aria-hidden="true"></i>
			</a>
			<span class="stext-109 cl4">
				Write
			</span>
		</div>
	</div>
	<section class="bg0 p-t-52 p-b-20">
	<div class="container">
		<div class="row">
			<div class="col-md-8 col-lg-9 p-b-80">
				<div class="p-r-45 p-r-0-lg">
					<!-- 글쓰기 폼 -->
					<form action="CommModifyPro.co" method="post" enctype="multipart/form-data">
	                	<input type="hidden" id="num" name="num" value="<%=article.getNum()%>">
						<span>썸네일</span>
						<div id="image_container" class="mg-b-5" style="width:60px; height:60px; border: 1px solid black;"></div>
						<label>현재 파일 :<img src="upload/commUpload/<%=article.getImg() %>" alt="<%=article.getImg() %>" style="width:50px;height: 50px;"></label><br>
						<input type="file" name="img" id="img" value="<%=article.getImg() %>" required="required"><br>
    					<label>제목 : </label>
     					<input type="text" id="subject" name="subject" value="<%=article.getSubject() %>" class="MS_input_txt input_style2" required="required"><br>
    					<label>비밀번호 확인 : </label>
    					<input type="password" id="pass" name="pass" class="MS_input_txt input_style2" required="required"><br>
						<textarea id ="summernote" name="content" ><%=article.getContent() %></textarea><br>
						<div class="flex-w flex-c-m m-tb-10 float-r" >
							<i class="cl2 m-r-6 fs-15 trans-04 zmdi zmdi-close dis-none"></i>
							<input type="submit" value="수정" class="flex-c-m stext-106 cl6 size-104 bor4 pointer hov-btn3 trans-04 m-r-8 m-tb-4 js-show-btn bg-none">
							<a href="CommList.co">
								<div class="flex-c-m stext-106 cl6 size-104 bor4 pointer hov-btn3 trans-04 m-r-8 m-tb-4 js-show-btn">
								<i class="cl2 m-r-6 fs-15 trans-04 zmdi zmdi-close dis-none"></i>
								글목록
								</div>
							</a>
						</div>
					</form>
					<!-- 글쓰기 폼 -->
				</div>
			</div>
			<div class="col-md-4 col-lg-3 p-b-80">
				<div class="side-menu">
					<div>
						<h4 class="mtext-112 cl2 p-b-33">
							Categories
						</h4>
						<ul>
							<li class="bor18">
								<a href="#" class="dis-block stext-115 cl6 hov-cl1 trans-04 p-tb-8 p-lr-4">
									Fashion
								</a>
							</li>
							<li class="bor18">
								<a href="#" class="dis-block stext-115 cl6 hov-cl1 trans-04 p-tb-8 p-lr-4">
									Beauty
								</a>
							</li>
							<li class="bor18">
								<a href="#" class="dis-block stext-115 cl6 hov-cl1 trans-04 p-tb-8 p-lr-4">
									Street Style
								</a>
							</li>
							<li class="bor18">
								<a href="#" class="dis-block stext-115 cl6 hov-cl1 trans-04 p-tb-8 p-lr-4">
									Life Style
								</a>
							</li>
							<li class="bor18">
								<a href="#" class="dis-block stext-115 cl6 hov-cl1 trans-04 p-tb-8 p-lr-4">
									DIY & Crafts
								</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="p-t-65">
					<h4 class="mtext-112 cl2 p-b-33">
						베스트 게시물
					</h4>
					<ul>
						<%for(CommBean cb : articleList){ %>
							<li class="flex-w flex-t p-b-30">
								<a href="#" class="wrao-pic-w size-214 hov-ovelay1 m-r-20">
									<img src="upload/commUpload/<%=cb.getImg() %>" alt="PRODUCT">
								</a>

								<div class="size-215 flex-col-t p-t-8">
									<a href="#" class="stext-116 cl8 hov-cl1 trans-04">
										<%=cb.getSubject() %>
									</a>

									<span class="stext-116 cl6 p-t-20">
										<%=cb.getUsername() %>
									</span>
								</div>
							</li>
						<%} %>
					</ul>
				</div>
				<div class="p-t-65">
					<h4 class="mtext-112 cl2 p-b-33">
						베스트 상품
					</h4>

					<ul>
						<%for(CommBean cb : articleList){ %>
							<li class="flex-w flex-t p-b-30">
								<a href="#" class="wrao-pic-w size-214 hov-ovelay1 m-r-20">
									<img src="upload/commUpload/<%=cb.getImg() %>" alt="PRODUCT">
								</a>

								<div class="size-215 flex-col-t p-t-8">
									<a href="#" class="stext-116 cl8 hov-cl1 trans-04">
										<%=cb.getSubject() %>
									</a>

									<span class="stext-116 cl6 p-t-20">
										<%=cb.getUsername() %>
									</span>
								</div>
							</li>
						<%} %>
					</ul>
				</div>
				<div class="p-t-50">
					<h4 class="mtext-112 cl2 p-b-27">
						Tags
					</h4>

					<div class="flex-w m-r--5">
						<a href="#" class="flex-c-m stext-107 cl6 size-301 bor7 p-lr-15 hov-tag1 trans-04 m-r-5 m-b-5">
							Fashion
						</a>

						<a href="#" class="flex-c-m stext-107 cl6 size-301 bor7 p-lr-15 hov-tag1 trans-04 m-r-5 m-b-5">
							Lifestyle
						</a>

						<a href="#" class="flex-c-m stext-107 cl6 size-301 bor7 p-lr-15 hov-tag1 trans-04 m-r-5 m-b-5">
							Denim
						</a>

						<a href="#" class="flex-c-m stext-107 cl6 size-301 bor7 p-lr-15 hov-tag1 trans-04 m-r-5 m-b-5">
							Streetstyle
						</a>

						<a href="#" class="flex-c-m stext-107 cl6 size-301 bor7 p-lr-15 hov-tag1 trans-04 m-r-5 m-b-5">
							Crafts
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
<script>
	function setThumbnail(event) {
			document.getElementById("file").select();
			document.selection.clear();
	};
	function setThumbnail(event) {
		var reader = new FileReader();
		reader.onload = function(event) {
			var img = document.createElement("img");
			img.setAttribute("src", event.target.result);
			img.setAttribute("style", "width:50px;");
			img.setAttribute("style", "height:50px;");
			document.querySelector("div#image_container").appendChild(img);
			
		};
		reader.readAsDataURL(event.target.files[0]);
	}
</script>
	<jsp:include page="../inc/footer.jsp" />
	<!-- WriteEditor -->
	<jsp:include page="../inc/writeEditor.jsp"/>
	<!-- WriteEditor -->
</body>
</html>