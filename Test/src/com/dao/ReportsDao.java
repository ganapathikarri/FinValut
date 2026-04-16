
package com.dao;

import java.util.List;

import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;

@Repository
public class ReportsDao {

	// ✅ 1. AVG MONTHLY INCOME
	public Double getAvgMonthlyIncome(String email) {

		Double monthlyIncome = 0.0;
		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();
			String sql = "SELECT AVG(month_total) FROM (" + " SELECT SUM(t.amount) AS month_total "
					+ " FROM transactions t " + " JOIN users u ON t.user_id = u.id "
					+ " WHERE u.email = :email AND LOWER(t.typ) = 'income' "
					+ " GROUP BY EXTRACT(YEAR FROM t.transaction_date), "
					+ "          EXTRACT(MONTH FROM t.transaction_date)" + ") AS monthly_data";
			SQLQuery sqlQuery = session.createSQLQuery(sql);
			sqlQuery.setParameter("email", email);

			Object result = sqlQuery.uniqueResult();

			if (result != null) {
				monthlyIncome = ((Number) result).doubleValue();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.close(); // ✅ safe close
			}
		}

		return monthlyIncome;
	}

	// ✅ 2. AVG MONTHLY EXPENSE
	public Double getAvgMonthlyExpenses(String email) {

		Double monthlyExpense = 0.0;
		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();

			String sql = "SELECT AVG(month_total) FROM (" + " SELECT SUM(t.amount) AS month_total "
					+ " FROM transactions t " + " JOIN users u ON t.user_id = u.id "
					+ " WHERE u.email = :email AND LOWER(t.typ) = 'expenses' "
					+ " GROUP BY EXTRACT(YEAR FROM t.transaction_date), "
					+ "          EXTRACT(MONTH FROM t.transaction_date)" + ") AS monthly_data";
			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object result = query.uniqueResult();

			if (result != null) {
				monthlyExpense = ((Number) result).doubleValue();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return monthlyExpense;
	}

	// ✅ 3. TOTAL INCOME
	public Double getTotalIncome(String email) {

		Double totalIncome = 0.0;
		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();

			String sql = "SELECT SUM(t.amount) " + "FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email AND LOWER(t.typ) = 'income'";

			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object result = query.uniqueResult();

			if (result != null) {
				totalIncome = ((Number) result).doubleValue();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return totalIncome;
	}

	// ✅ 4. TOTAL EXPENSE
	public Double getTotalExpense(String email) {

		Double totalExpense = 0.0;
		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();

			String sql = "SELECT SUM(t.amount) " + "FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email AND LOWER(t.typ) = 'expenses'";

			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object result = query.uniqueResult();

			if (result != null) {
				totalExpense = ((Number) result).doubleValue();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return totalExpense;
	}

	public Double getSavingsRate(String email) {

		Double savingsRate = 0.0;
		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();

			String sql = "SELECT ((income - expense) / NULLIF(income,0)) * 100 " + "FROM (" + " SELECT "
					+ "   SUM(CASE WHEN LOWER(t.typ) = 'income' THEN t.amount ELSE 0 END) AS income, "
					+ "   SUM(CASE WHEN LOWER(t.typ) = 'expenses' THEN t.amount ELSE 0 END) AS expense "
					+ " FROM transactions t " + " JOIN users u ON t.user_id = u.id " + " WHERE u.email = :email"
					+ ") x";
			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object result = query.uniqueResult();

			if (result != null) {
				savingsRate = ((Number) result).doubleValue();
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return savingsRate;
	}

	public List<Object[]> getMonthlyIncome(String email) {

		Session session = null;
		List<Object[]> list = null;

		try {
			session = HibernateSessionFactory.getSession();

			String sql = "SELECT EXTRACT(MONTH FROM t.transaction_date) AS month, " + "SUM(t.amount) "
					+ "FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email AND t.typ ILIKE '%income%' " + "GROUP BY month ORDER BY month";

			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			list = query.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return list;
	}

	public List<Object[]> getMonthlyExpense(String email) {

		Session session = null;
		List<Object[]> list = null;

		try {
			session = HibernateSessionFactory.getSession();

			String sql = "SELECT EXTRACT(MONTH FROM t.transaction_date) AS month, " + "SUM(t.amount) "
					+ "FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email AND t.typ ILIKE '%expense%' " + "GROUP BY month ORDER BY month";

			SQLQuery query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			list = query.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return list;
	}

}
