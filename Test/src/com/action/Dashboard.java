package com.action;

import java.sql.Timestamp;
import java.text.DateFormatSymbols;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.dao.DashboardDAO;
import com.dao.LoginDetails;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.vo.Categories;
import com.vo.Transactions;
import com.vo.Users;

@Controller
public class Dashboard {
	LoginDetails login = new LoginDetails();

	DashboardDAO dashboardDAO = new DashboardDAO();

	@RequestMapping("/budget")
	public ModelAndView getBydget() {
		return new ModelAndView("budget");
	}

	@RequestMapping("/income")
	public ModelAndView getDashboard(HttpServletRequest request) {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("email") == null) {
			return new ModelAndView("redirect:/login");
		}

		String email = (String) session.getAttribute("email");

		DashboardDAO dao = new DashboardDAO();

		Double thisMonth = dao.getThisMonthIncome(email);
		Double lastMonth = dao.getLastMonthIncome(email);
		Double thisYear = dao.getThisYearIncome(email);
		List<Object[]> data = dao.getMonthlyIncome(email);

		List<String> months = new ArrayList<>();
		List<Double> values = new ArrayList<>();

		for (Object[] row : data) {

			int monthNum = ((Number) row[0]).intValue();
			double amount = ((Number) row[1]).doubleValue();

			// Convert number → month name
			String monthName = new DateFormatSymbols().getShortMonths()[monthNum - 1];

			months.add(monthName);
			values.add(amount);
		}

		List<Object[]> Dountdata = dao.getIncomeByType(email);

		List<String> categories = new ArrayList<>();
		List<Double> categoryAmounts = new ArrayList<>();

		for (Object[] row : Dountdata) {

			String type = (String) row[0];
			double amount = ((Number) row[1]).doubleValue(); // IMPORTANT

			categories.add(type);
			categoryAmounts.add(amount);
		}
		String type = "income";
		List<Object[]> incomeRows = dao.getAllIncomes(email, type);

		List<Object[]> incomes = dao.getAllIncomes(email, type);

		ModelAndView mv = new ModelAndView("income");

		mv.addObject("categories", categories);
		mv.addObject("categoryAmounts", categoryAmounts);

		Double avgMonthly = thisYear / 12;
		mv.addObject("months", months);
		mv.addObject("values", values);
		// mv.addObject("months",months);
		mv.addObject("thisMonth", thisMonth);
		mv.addObject("lastMonth", lastMonth);
		mv.addObject("thisYear", thisYear);
		mv.addObject("avgMonthly", avgMonthly);
		mv.addObject("incomes", incomes);
		mv.addObject("incomes", incomes);
		return mv;
	}

	@RequestMapping("/expenses")
	public ModelAndView getExpenses(HttpServletRequest request) {

		HttpSession session = request.getSession(false);

		if (session == null || session.getAttribute("email") == null) {
			return new ModelAndView("redirect:/login");
		}

		String email = (String) session.getAttribute("email");

		DashboardDAO dao = new DashboardDAO();
//
		Double thisMonth = dao.getThisMonthExpenses(email);
		Double lastMonth = dao.getLastMonthExpense(email);
		Double thisYear = dao.getThisYearExpense(email);
//	    List<Object[]> data = dao.getMonthlyIncome(email);
//
//	    List<String> months = new ArrayList<>();
//	    Lists<Double> values = new ArrayList<>();
//
//	    for (Object[] row : data) {
//
//	        int monthNum = ((Number) row[0]).intValue();
//	        double amount = ((Number) row[1]).doubleValue();
//
//	        // Convert number → month name
//	        String monthName = new DateFormatSymbols().getShortMonths()[monthNum - 1];
//
//	        months.add(monthName);
//	        values.add(amount);
//	    }
//
//	    List<Object[]> Dountdata = dao.getIncomeByType(email);
//
//	    List<String> categories = new ArrayList<>();
//	    List<Double> categoryAmounts = new ArrayList<>();
//
//	    for (Object[] row : Dountdata) {
//
//	        String type = (String) row[0];
//	        double amount = ((Number) row[1]).doubleValue(); // IMPORTANT
//
//	        categories.add(type);
//	        categoryAmounts.add(amount);
//	    }
		String type = "/expenses";
		List<Object[]> incomeRows = dao.getallexpenses(email, type);
//
		List<Object[]> incomes = dao.getallexpenses(email, type);
//	    
//
		ModelAndView mv = new ModelAndView("expenses");
//
//	    mv.addObject("categories", categories);
//	    mv.addObject("categoryAmounts", categoryAmounts);
//
//	    Double avgMonthly = thisYear / 12;
//	    mv.addObject("months", months);
//	    mv.addObject("values", values);
//	    //mv.addObject("months",months);
		mv.addObject("thisMonth", thisMonth);
		mv.addObject("lastMonth", lastMonth);
		mv.addObject("thisYear", thisYear);
//	    mv.addObject("avgMonthly", avgMonthly);
		mv.addObject("expenses", incomes);
		return mv;
	}

	@RequestMapping("/goals")
	public ModelAndView getGoals() {
		return new ModelAndView("goals");
	}

	@RequestMapping("/reports")
	public ModelAndView getReports() {
		return new ModelAndView("reports");
	}

	@RequestMapping("/deleteExpense")
	public String deleteExpense(@RequestParam("id") int id) {

		DashboardDAO dao = new DashboardDAO();
		dao.deleteExpense(id);

		return "redirect:/expenses"; // reload page
	}

	@RequestMapping(value = "/addIncome", method = RequestMethod.POST)
	public ModelAndView addIncome(HttpServletRequest request) throws ParseException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("email") == null) {
			return new ModelAndView("login");
		}
		String email = (String) session.getAttribute("email");
		Users user = login.getByEmail(email);

		Categories cate = new Categories();
		cate.setId(dashboardDAO.getMaxCategoriesId() + 1);
		cate.setUsers(user);
		cate.setTyp(request.getParameter("type"));
		cate.setCategoriename(request.getParameter("source"));
		dashboardDAO.saveCategoDetails(cate);

		Transactions transactions = new Transactions();

		transactions.setId(dashboardDAO.getMaxTransctionId() + 1);
		transactions.setUsers(user);
		transactions.setCategories(cate);
		Double ammount = Double.parseDouble(request.getParameter("amount"));
		transactions.setAmount(ammount);
		String date = request.getParameter("date");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date parsedDate = dateFormat.parse(date);
		Timestamp timestamp = new Timestamp(parsedDate.getTime());
		transactions.setTyp("income");
		transactions.setDescription(request.getParameter("note"));
		transactions.setTransactionDate(timestamp);

		dashboardDAO.saveTranscationDetails(transactions);

		return new ModelAndView("redirect:/income");
	}

	@RequestMapping(value = "/addExpenses", method = RequestMethod.POST)
	public ModelAndView addExpenses(HttpServletRequest request) throws ParseException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("email") == null) {
			return new ModelAndView("login");
		}
		String email = (String) session.getAttribute("email");
		Users user = login.getByEmail(email);

		Categories cate = new Categories();
		cate.setId(dashboardDAO.getMaxCategoriesId() + 1);
		cate.setUsers(user);
		cate.setTyp(request.getParameter("note"));
		cate.setCategoriename(request.getParameter("category"));
		dashboardDAO.saveCategoDetails(cate);

		Transactions transactions = new Transactions();

		transactions.setId(dashboardDAO.getMaxTransctionId() + 1);
		transactions.setUsers(user);
		transactions.setCategories(cate);
		Double ammount = Double.parseDouble(request.getParameter("amount"));
		transactions.setAmount(ammount);
		String date = request.getParameter("date");
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date parsedDate = dateFormat.parse(date);
		Timestamp timestamp = new Timestamp(parsedDate.getTime());
		transactions.setTyp("expenses");
		transactions.setDescription(request.getParameter("note"));
		transactions.setTransactionDate(timestamp);

		dashboardDAO.saveTranscationDetails(transactions);

		return new ModelAndView("redirect:/expenses");
	}

	@RequestMapping("/income/export")
	public void exportIncome(HttpServletResponse response, HttpSession session) throws Exception {

		String email = (String) session.getAttribute("email");

		List<Object[]> list = dashboardDAO.getIncomeForExport(email);

		response.setContentType("application/pdf");
		response.setHeader("Content-Disposition", "attachment; filename=income_report.pdf");

		Document document = new Document(PageSize.A4);
		PdfWriter.getInstance(document, response.getOutputStream());

		document.open();

		// =========================
		// 🟢 TITLE
		// =========================
		Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
		Paragraph title = new Paragraph("FinVault Income Report", titleFont);
		title.setAlignment(Element.ALIGN_CENTER);
		document.add(title);

		document.add(new Paragraph(" "));

		// =========================
		// 🟢 USER INFO
		// =========================
		document.add(new Paragraph("User: " + email));
		document.add(new Paragraph("Generated on: " + new Date()));
		document.add(new Paragraph(" "));

		// =========================
		// 🟢 SUMMARY CALCULATION
		// =========================
		double total = 0;
		double max = 0;

		for (Object[] row : list) {
			double amount = (Double) row[4];
			total += amount;
			if (amount > max)
				max = amount;
		}

		Font summaryFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);

		document.add(new Paragraph("Total Income: ₹ " + (long) total, summaryFont));
		document.add(new Paragraph("Transactions: " + list.size(), summaryFont));
		document.add(new Paragraph("Highest Income: ₹ " + (long) max, summaryFont));

		document.add(new Paragraph(" "));

		// =========================
		// 🟢 TABLE
		// =========================
		PdfPTable table = new PdfPTable(5);
		table.setWidthPercentage(100);
		table.setSpacingBefore(10f);

		float[] columnWidths = { 2f, 2f, 2f, 3f, 2f };
		table.setWidths(columnWidths);

		Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

		// Header cells
		addHeaderCell(table, "Source", headerFont);
		addHeaderCell(table, "Type", headerFont);
		addHeaderCell(table, "Date", headerFont);
		addHeaderCell(table, "Note", headerFont);
		addHeaderCell(table, "Amount", headerFont);

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

		// =========================
		// 🟢 TABLE DATA
		// =========================
		for (Object[] row : list) {

			table.addCell(row[0] != null ? row[0].toString() : "");
			table.addCell(row[1] != null ? row[1].toString() : "");

			Date date = (Date) row[2];
			table.addCell(date != null ? sdf.format(date) : "");

			table.addCell(row[3] != null ? row[3].toString() : "");

			PdfPCell amountCell = new PdfPCell(new Phrase("₹ " + String.valueOf(Math.round((Double) row[4]))));
			amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
			table.addCell(amountCell);
		}

		document.add(table);

		// =========================
		// 🟢 FOOTER
		// =========================
		document.add(new Paragraph(" "));
		document.add(new Paragraph("Generated by FinVault"));

		document.close();

	}

	@RequestMapping("/expenses/export")
	public void getExpenseForExport(HttpServletResponse response, HttpSession session) throws Exception {

		String email = (String) session.getAttribute("email");

		List<Object[]> list = dashboardDAO.getExpenseForExport(email);

		response.setContentType("application/pdf");
		response.setHeader("Content-Disposition", "attachment; filename=expenses_report.pdf");

		Document document = new Document(PageSize.A4);
		PdfWriter.getInstance(document, response.getOutputStream());

		document.open();

		// =========================
		// 🟢 TITLE
		// =========================
		Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
		Paragraph title = new Paragraph("FinVault Income Report", titleFont);
		title.setAlignment(Element.ALIGN_CENTER);
		document.add(title);

		document.add(new Paragraph(" "));

		// =========================
		// 🟢 USER INFO
		// =========================
		document.add(new Paragraph("User: " + email));
		document.add(new Paragraph("Generated on: " + new Date()));
		document.add(new Paragraph(" "));

		// =========================
		// 🟢 SUMMARY CALCULATION
		// =========================
		double total = 0;
		double max = 0;

		for (Object[] row : list) {
			double amount = (Double) row[4];
			total += amount;
			if (amount > max)
				max = amount;
		}

		Font summaryFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);

		document.add(new Paragraph("Total Income: ₹ " + (long) total, summaryFont));
		document.add(new Paragraph("Transactions: " + list.size(), summaryFont));
		document.add(new Paragraph("Highest Income: ₹ " + (long) max, summaryFont));

		document.add(new Paragraph(" "));

		// =========================
		// 🟢 TABLE
		// =========================
		PdfPTable table = new PdfPTable(5);
		table.setWidthPercentage(100);
		table.setSpacingBefore(10f);

		float[] columnWidths = { 2f, 2f, 2f, 3f, 2f };
		table.setWidths(columnWidths);

		Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD);

		// Header cells
		addHeaderCell(table, "Source", headerFont);
		addHeaderCell(table, "Type", headerFont);
		addHeaderCell(table, "Date", headerFont);
		addHeaderCell(table, "Note", headerFont);
		addHeaderCell(table, "Amount", headerFont);

		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");

		// =========================
		// 🟢 TABLE DATA
		// =========================
		for (Object[] row : list) {

			table.addCell(row[0] != null ? row[0].toString() : "");
			table.addCell(row[1] != null ? row[1].toString() : "");

			Date date = (Date) row[2];
			table.addCell(date != null ? sdf.format(date) : "");

			table.addCell(row[3] != null ? row[3].toString() : "");

			PdfPCell amountCell = new PdfPCell(new Phrase("₹ " + String.valueOf(Math.round((Double) row[4]))));
			amountCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
			table.addCell(amountCell);
		}

		document.add(table);

		// =========================
		// 🟢 FOOTER
		// =========================
		document.add(new Paragraph(" "));
		document.add(new Paragraph("Generated by FinVault"));

		document.close();

	}

// =========================
// 🟢 HEADER CELL METHOD
// =========================
	private void addHeaderCell(PdfPTable table, String text, Font font) {
		PdfPCell header = new PdfPCell(new Phrase(text, font));
		header.setBackgroundColor(BaseColor.LIGHT_GRAY);
		header.setHorizontalAlignment(Element.ALIGN_CENTER);
		header.setPadding(5);
		table.addCell(header);
	}

}
