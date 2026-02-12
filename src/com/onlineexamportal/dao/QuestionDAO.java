package com.onlineexamportal.dao;

import com.onlineexamportal.model.Question;
import com.onlineexamportal.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    // Add question
    public boolean addQuestion(Question q) {
        String sql = "INSERT INTO questions (exam_id, question, option1, option2, option3, option4, answer) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, q.getExamId());
            ps.setString(2, q.getQuestion());
            ps.setString(3, q.getOption1());
            ps.setString(4, q.getOption2());
            ps.setString(5, q.getOption3());
            ps.setString(6, q.getOption4());
            ps.setString(7, q.getAnswer());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all questions for an exam
    public List<Question> getQuestionsByExamId(int examId) {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM questions WHERE exam_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, examId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Question q = new Question();
                q.setId(rs.getInt("id"));
                q.setExamId(rs.getInt("exam_id"));
                q.setQuestion(rs.getString("question"));
                q.setOption1(rs.getString("option1"));
                q.setOption2(rs.getString("option2"));
                q.setOption3(rs.getString("option3"));
                q.setOption4(rs.getString("option4"));
                q.setAnswer(rs.getString("answer"));
                questions.add(q);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

        public void updateQuestion(int id, String question,
                           String o1, String o2,
                           String o3, String o4,
                           String answer) {

    String sql = "UPDATE questions SET question=?, option1=?, option2=?, option3=?, option4=?, answer=? WHERE id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, question);
        ps.setString(2, o1);
        ps.setString(3, o2);
        ps.setString(4, o3);
        ps.setString(5, o4);
        ps.setString(6, answer);
        ps.setInt(7, id);

        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}


public void deleteQuestion(int id) {

    String sql = "DELETE FROM questions WHERE id=?";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, id);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}


    

    public List<Question> getQuestionsByExam(int examId) 
    { 
            return getQuestionsByExamId(examId);
    }

}
