package com.action;

import java.sql.Timestamp;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.dao.DashboardDAO;
import com.dao.LoginDetails;
import com.vo.Users;

@Controller
public class Login {

	LoginDetails login = new LoginDetails();

	@RequestMapping("/register")
	public ModelAndView showRegisterPage() {
		return new ModelAndView("register");
	}

	@RequestMapping(value = "/registerSubmittion", method = RequestMethod.POST)
	public ModelAndView register(HttpServletRequest request) {

		// 🔹 Get form data
		String firstName = request.getParameter("firstName");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		String password = request.getParameter("password");
		String repassword = request.getParameter("confornpassword");
		String currency = request.getParameter("currency");
		String monthlyIncome = request.getParameter("monthlyIncome");
		String useragre = request.getParameter("agreeTerms");
		// 🔹 Validation
		if (login.isEmailExists(email)) {
			ModelAndView mv = new ModelAndView("register");
			mv.addObject("error", "Email already exists!");
			return mv;
		}

		// 🔹 Map to User object
		Users user = new Users();
		user.setUsername(firstName); // mapping UI → DB
		user.setEmail(email);
		user.setUserpass(password);
	
		user.setMonthlyIncome(Integer.parseInt(monthlyIncome));
		user.setPhone(phone);
		user.setCreatedAt(new Timestamp(System.currentTimeMillis()));

		// (Optional fields - only if added in DB & class)
		try {
			if (monthlyIncome != null && !monthlyIncome.isEmpty()) {
				// only if you added this field in Users class
				// user.setMonthlyIncome(Double.parseDouble(monthlyIncome));
				user.setMonthlyIncome(Integer.parseInt(monthlyIncome));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 🔹 Save user
		user.setId(login.getMaxid() + 1);
		boolean isvalid = login.saveUserDetails(user);

		if (isvalid) {
			ModelAndView mv = new ModelAndView("login");
			mv.addObject("success", "Registration successful! Please login.");
			return mv;
		} else {
			ModelAndView mv = new ModelAndView("register");
			mv.addObject("error", "Registration failed!");
			return mv;
		}
	}

	@RequestMapping("/dashboard")
	public ModelAndView viewDashboard(HttpServletRequest request) {
		HttpSession session = request.getSession(false);
		DashboardDAO dashboardDAO = new DashboardDAO();
	    if (session == null || session.getAttribute("email") == null) {
	        return new ModelAndView("redirect:/login");
	    }

	    String email = (String) session.getAttribute("email");
		ModelAndView mv = new ModelAndView("dashboard");
		Double income = dashboardDAO.getThisMonthIncome(email);
		Double expense = dashboardDAO.getThisMonthExpenses(email);
		 List<Object[]> topCategories = dashboardDAO.getTopCategories(email);

		income = (income != null) ? income : 0.0;
		expense = (expense != null) ? expense : 0.0;
		Double netBalance = income - expense;
		Double saving = income - expense;
		mv.addObject("monthlyIncome", income);
		mv.addObject("monthlyExpense", expense);
		mv.addObject("netBalance", netBalance);
		mv.addObject("monthlySaving", saving);
		mv.addObject("topCategories", topCategories);

		
		return mv;
	}
	@RequestMapping("/login")
	public ModelAndView getLogin() {
		return new ModelAndView("login");
	}
	
	@RequestMapping(value = "/submit", method = RequestMethod.POST)
	public ModelAndView login(HttpServletRequest request, @RequestParam("email") String getEmail,
			@RequestParam("password") String password) {
		boolean isvalid = false;
		isvalid = login.fetchUserDetails(getEmail, password);
		if (isvalid == true) {
			HttpSession session = request.getSession();
			session.setAttribute("email", getEmail);
			return new ModelAndView("redirect:/dashboard");
		} else {
			System.out.println("INVALID ");
			return new ModelAndView("login");
		}
	}

}
