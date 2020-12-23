package action.community;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import action.Action;
import svc.community.CommDeleteProService;
import svc.community.CommModifyProService;
import vo.ActionForward;

public class CommDeleteProAction implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		System.out.println("CommDeleteProAction!");
		ActionForward forward = null;
		String pass = request.getParameter("pass");
		int num = Integer.parseInt(request.getParameter("num"));
		HttpSession session = request.getSession();
		String member_id = (String)session.getAttribute("member_id");
		CommModifyProService commModifyProService = new CommModifyProService();
		CommDeleteProService commDeleteProService = new CommDeleteProService();
		
		// 비밀번호 맞는 지 검증
		boolean check = commModifyProService.isArticleWriter(member_id,pass);
		
		if(!check) {
			// 틀렸을 경우
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.println("<script>");
			out.println("alert('비밀번호 오류!')");
			out.println("history.back()");
			out.println("</script>");
		}else {
			// 일치할 경우 삭제 작업
			boolean isDeleteSuccess = commDeleteProService.removeArticle(num);
			if(!isDeleteSuccess) {
				// 삭제 실패 시
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out = response.getWriter();
				out.println("<script>");
				out.println("alert('글 삭제 실패!!')");
				out.println("history.back()");
				out.println("</script>");
			}else {
				// 삭제 성공 시
				forward = new ActionForward();
				forward.setPath("CommList.co?num="+num+"&page="+request.getParameter("page"));
				forward.setRedirect(true);
			}
		}
		
		return forward;
	}

}
