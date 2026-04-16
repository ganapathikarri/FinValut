package com.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dao.ReportsDao;

@RestController // 🔥 NOT @Controller
@RequestMapping("/api")
public class Reports {

	@Autowired
	private ReportsDao report;

	@RequestMapping(value = "/reports", produces = "application/json")
	public Map<String, Object> getReports(HttpServletRequest request) {

		HttpSession session = request.getSession(false);

		String email = (session != null) ? (String) session.getAttribute("email") : "test@gmail.com";

		Map<String, Object> response = new HashMap<>();

		response.put("avgIncome", report.getAvgMonthlyIncome(email));
		response.put("avgExpense", report.getAvgMonthlyExpenses(email));
		response.put("savingsRate", report.getSavingsRate(email));
		List<Object[]> incomeData = report.getMonthlyIncome(email);
	    List<Object[]> expenseData = report.getMonthlyExpense(email);

	    List<String> months = new ArrayList<>();
	    List<Double> incomes = new ArrayList<>();
	    List<Double> expenses = new ArrayList<>();

	    // Convert income
	    for (Object[] row : incomeData) {
	        int month = ((Number) row[0]).intValue();
	        double amount = ((Number) row[1]).doubleValue();

	        months.add(getMonthName(month));
	        incomes.add(amount);
	    }

	    // Convert expense
	    for (Object[] row : expenseData) {
	        double amount = ((Number) row[1]).doubleValue();
	        expenses.add(amount);
	    }

	    response.put("months", months);
	    response.put("incomeList", incomes);
	    response.put("expenseList", expenses);

		return response;
	}
	private String getMonthName(int m) {

	    String[] names = {
	        "Jan","Feb","Mar","Apr","May","Jun",
	        "Jul","Aug","Sep","Oct","Nov","Dec"
	    };

	    return names[m - 1];
	}

}
