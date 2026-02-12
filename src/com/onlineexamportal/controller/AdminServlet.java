//----------------------------------------------------

package com.onlineexamportal.controller;

import com.onlineexamportal.dao.ExamDAO;
import com.onlineexamportal.dao.QuestionDAO;
import com.onlineexamportal.model.Exam;
import com.onlineexamportal.model.Question;
import com.onlineexamportal.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;


// import org.apache.pdfbox.pdmodel.PDDocument;
// import org.apache.pdfbox.text.PDFTextStripper;

@WebServlet("/admin")
@MultipartConfig
public class AdminServlet extends HttpServlet {

    private ExamDAO examDAO;
    private QuestionDAO questionDAO;

    @Override
    public void init() {
        examDAO = new ExamDAO();
        questionDAO = new QuestionDAO();
    }

    // ===================== POST =====================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("admin.jsp?error=InvalidAction");
            return;
        }

        try {
            switch (action) {
                case "addExam":
                    addExam(request, response);
                    break;
                case "addQuestion":
                    addQuestion(request, response);
                    break;
                
                case "addMultipleQuestions":
                    addMultipleQuestions(request,response);
                    break;

                case "updateQuestion":
                    updateQuestion(request, response);
                    break;

                case "deleteQuestion":
                    deleteQuestion(request, response);
                    break;

                case "rescheduleExam":
                    rescheduleExam(request, response);
                    break;  


                
                case "deleteExam":
                    int examId = Integer.parseInt(request.getParameter("examId"));
                    examDAO.deleteExam(examId);
                    response.sendRedirect("admin.jsp?success=ExamDeleted");
                    break;
                
                

                default:
                    response.sendRedirect("admin.jsp?error=UnknownAction");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin.jsp?error=ServerError");
        }
    }

    // ===================== GET =====================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if ("deleteExam".equals(action)) {
            int examId = Integer.parseInt(request.getParameter("examId"));

            
            examDAO.deleteExam(examId);

        // request.getRequestDispatcher("admin.jsp").forward(request, response);
        response.sendRedirect("admin.jsp?success=ExamDeleted");


    }
    }
//===========================RESCHEDULE EXAM===========================

    private void rescheduleExam(HttpServletRequest request,
                            HttpServletResponse response) throws IOException {

    int userId = Integer.parseInt(request.getParameter("userId"));
    int examId = Integer.parseInt(request.getParameter("examId"));

    try (java.sql.Connection conn =
             com.onlineexamportal.util.DBConnection.getConnection()) {

        conn.setAutoCommit(false);

        try (
            java.sql.PreparedStatement ps1 =
                conn.prepareStatement(
                    "DELETE FROM result_details WHERE user_id=? AND exam_id=?");
            java.sql.PreparedStatement ps2 =
                conn.prepareStatement(
                    "DELETE FROM results WHERE user_id=? AND exam_id=?")
        ) {
            ps1.setInt(1, userId);
            ps1.setInt(2, examId);
            ps1.executeUpdate();

            ps2.setInt(1, userId);
            ps2.setInt(2, examId);
            ps2.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            conn.rollback();
            throw e;
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("admin.jsp?error=RescheduleFailed");
        return;
    }

    response.sendRedirect("admin.jsp?success=ExamRescheduled");
}

    // ===================== ADD EXAM =====================
    private void addExam(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("examName");
        int duration = Integer.parseInt(request.getParameter("duration"));

        Exam exam = new Exam();
        exam.setName(name);
        exam.setDuration(duration);

        examDAO.addExam(exam);
        response.sendRedirect("admin.jsp?success=ExamAdded");
    }

    // ===================== ADD QUESTION =====================
    private void addQuestion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int examId = Integer.parseInt(request.getParameter("examId"));
        String question = request.getParameter("question");
        String option1 = request.getParameter("option1");
        String option2 = request.getParameter("option2");
        String option3 = request.getParameter("option3");
        String option4 = request.getParameter("option4");
        String answer = request.getParameter("answer");

        Question q = new Question();
        q.setExamId(examId);
        q.setQuestion(question);
        q.setOption1(option1);
        q.setOption2(option2);
        q.setOption3(option3);
        q.setOption4(option4);
        q.setAnswer(answer);

        questionDAO.addQuestion(q);
        response.sendRedirect("admin.jsp?success=QuestionAdded");
    }

    //===============ADD multiple questions (bulk pasting)=============
    
    private void addMultipleQuestions(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

    int examId = Integer.parseInt(request.getParameter("examId"));
    String bulkText = request.getParameter("bulkQuestions");

    if (bulkText == null || bulkText.trim().isEmpty()) {
        response.sendRedirect("admin.jsp?error=NoQuestions");
        return;
    }

    // Split questions by double line breaks (empty line between questions)
    String[] blocks = bulkText.split("\\r?\\n\\r?\\n");

    for (String block : blocks) {
        String[] lines = block.split("\\r?\\n");

        if (lines.length >= 6) { // Must have question + 4 options + answer
            Question q = new Question();
            q.setExamId(examId);

            // Remove numbering like "1. " from the question
            String questionLine = lines[0].replaceAll("^\\d+\\.\\s*", "");
            q.setQuestion(questionLine.trim());

            // Remove "A) " etc from options
            q.setOption1(lines[1].replaceAll("^[A-D]\\)\\s*", "").trim());
            q.setOption2(lines[2].replaceAll("^[A-D]\\)\\s*", "").trim());
            q.setOption3(lines[3].replaceAll("^[A-D]\\)\\s*", "").trim());
            q.setOption4(lines[4].replaceAll("^[A-D]\\)\\s*", "").trim());

            // Extract answer text only (remove "Answer: " and letter)
            String answer = lines[5].replaceAll("^Answer:\\s*[A-D]\\)\\s*", "").trim();
            q.setAnswer(answer);

            questionDAO.addQuestion(q);
        }
    }

    response.sendRedirect("admin.jsp?success=QuestionsAdded");
}



// ===================== UPDATE QUESTION =====================
private void updateQuestion(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

    int questionId = Integer.parseInt(request.getParameter("questionId"));

    String question = request.getParameter("question");
    String option1  = request.getParameter("option1");
    String option2  = request.getParameter("option2");
    String option3  = request.getParameter("option3");
    String option4  = request.getParameter("option4");
    String answer   = request.getParameter("answer");

    questionDAO.updateQuestion(
        questionId, question, option1, option2, option3, option4, answer
    );

    response.sendRedirect("admin.jsp?success=QuestionUpdated");
}


// ===================== DELETE QUESTION =====================
private void deleteQuestion(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

    int questionId = Integer.parseInt(request.getParameter("questionId"));

    questionDAO.deleteQuestion(questionId);

    response.sendRedirect("admin.jsp?success=QuestionDeleted");
}







// ===================== AUTH CHECK =====================
private boolean isAdmin(HttpServletRequest request) {
    HttpSession session = request.getSession(false);
    if (session == null) return false;
    
    User user = (User) session.getAttribute("user");
    return user != null && "admin".equalsIgnoreCase(user.getRole());
}


}









