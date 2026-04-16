package com.dao;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.vo.Categories;
import com.vo.Transactions;

public class DashboardDAO {
	
	public List<Object[]> getTopCategories(String email) {

	    Session session = HibernateSessionFactory.getSession();

	    String hql = "select c.categoriename, SUM(t.amount) " +
	                 "from Transactions t " +
	                 "join t.categories c " +
	                 "join t.users u " +
	                 "where u.email = :email " +
	                 " and t.typ='expenses' "+
	                 "group by c.categoriename " +
	                 "order by SUM(t.amount) desc";

	    Query query = session.createQuery(hql);
	    query.setParameter("email", email);

	    return query.list();
	}

	public List<Object[]> getallexpenses(String email, String type) {
		List<Object[]> list = new ArrayList<Object[]>();
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			LocalDate now = LocalDate.now();

			LocalDate start = now.withDayOfMonth(1);

			LocalDate end = start.plusMonths(1);

			Timestamp startDate = Timestamp.valueOf(start.atStartOfDay());
			Timestamp endDate = Timestamp.valueOf(end.atStartOfDay());

			String hql = "select c.categoriename,c.typ,t.transactionDate,t.description,t.amount "
					+ "from Transactions t join t.categories c join t.users u where u.email=:email "
					+ "and t.typ=:type and t.transactionDate>=:startDate "
					+ "and t.transactionDate < :endDate order by t.transactionDate desc";

			Query query = session.createQuery(hql);
			query.setParameter("email", email);
			query.setParameter("type", type);
			query.setParameter("startDate", startDate);
			query.setParameter("endDate", endDate);

			list = query.list();

		} catch (Exception e) {

			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return list;
	}

	public List<Object[]> getAllIncomes(String email, String type) {

		Session session = HibernateSessionFactory.getSession();
		List<Object[]> list = null;

		try {
			// 🔥 Step 1: calculate dates
			LocalDate now = LocalDate.now();
			LocalDate start = now.withDayOfMonth(1);
			LocalDate end = start.plusMonths(1);

			Timestamp startDate = Timestamp.valueOf(start.atStartOfDay());
			Timestamp endDate = Timestamp.valueOf(end.atStartOfDay());

			// 🔥 Step 2: HQL
			String hql = "select c.categoriename,c.typ,t.transactionDate,t.description,t.amount, t.id "
			           + "from Transactions t join t.categories c join t.users u "
			           + "where u.email=:email "
			           + "and t.typ=:type "
			           + "and t.transactionDate>=:startDate "
			           + "and t.transactionDate < :endDate "
			           + "order by t.transactionDate desc";
			Query query = session.createQuery(hql);

			// 🔥 Step 3: set parameters
			query.setParameter("email", email);
			query.setParameter("type", type);
			query.setParameter("startDate", startDate);
			query.setParameter("endDate", endDate);

			list = query.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return list;
	}

	public List<Object[]> getIncomeByType(String email) {

		Session session = HibernateSessionFactory.getSession();
		List<Object[]> list = null;

		try {
			String hql = "select c.typ, sum(t.amount) " + "from Transactions t " + "join t.categories c "
					+ "join t.users u " + "where u.email = :email " + "group by c.typ " + "order by sum(t.amount) desc";

			Query query = session.createQuery(hql);
			query.setParameter("email", email);

			list = query.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			session.close();
		}

		return list;
	}

	public List<Object[]> getMonthlyIncome(String email) {

		Session session = HibernateSessionFactory.getSession();
		List<Object[]> list = null;

		try {
			String sql = "SELECT EXTRACT(MONTH FROM t.transaction_date) AS month, " + "SUM(t.amount) AS total "
					+ "FROM transactions t " + "JOIN users u ON t.user_id = u.id " + "WHERE u.email = :email "
					+ "AND t.typ = 'income' " + "GROUP BY month ORDER BY month";
			Query query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			list = query.list();

		} finally {
			session.close();
		}

		return list;
	}

	public Double getTotalincome(Integer userId) {
		Double totalExpense = 0.0;

		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();

			Query query = session
					.createQuery("select sum(amount) from Transactions where type = 'income' and users.id = :userId");

			query.setParameter("userId", userId);

			totalExpense = (Double) query.uniqueResult();

			if (totalExpense == null) {
				totalExpense = 0.0;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return totalExpense;
	}

	public Double getTotalExpense(Integer userId) {
		Double totalExpense = 0.0;

		Session session = null;

		try {
			session = HibernateSessionFactory.getSession();

			Query query = session
					.createQuery("select sum(amount) from Transactions where type = 'expense' and users.id = :userId");

			query.setParameter("userId", userId);

			totalExpense = (Double) query.uniqueResult();

			if (totalExpense == null) {
				totalExpense = 0.0;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return totalExpense;
	}

	public Integer getMaxTransctionId() {
		Session session = null;
		Integer maxTransId = null;

		try {
			session = HibernateSessionFactory.getSession();
			String hql = "select max(id) from Transactions";
			Query query = session.createQuery(hql);
			maxTransId = (Integer) query.uniqueResult();
			if (maxTransId == null) {
				maxTransId = 0;
			}

		} catch (Exception e) {

			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		return maxTransId;
	}

	public Integer getMaxCategoriesId() {
		Session session = null;
		Integer maxTransId = null;

		try {
			session = HibernateSessionFactory.getSession();
			String hql = "select max(id) from Transactions";
			Query query = session.createQuery(hql);
			maxTransId = (Integer) query.uniqueResult();
			if (maxTransId == null) {
				maxTransId = 0;
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		return maxTransId;
	}

	public boolean saveCategoDetails(Categories user) {

		Session session = null;
		org.hibernate.Transaction tx = null;
		try {
			session = HibernateSessionFactory.getSession();
			tx = session.beginTransaction();
			session.saveOrUpdate(user);

			tx.commit();
			return true;

		} catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return false;
	}

	public boolean saveTranscationDetails(Transactions user) {

		Session session = null;
		org.hibernate.Transaction tx = null;
		try {
			session = HibernateSessionFactory.getSession();
			tx = session.beginTransaction();
			session.saveOrUpdate(user);

			tx.commit();
			return true;

		} catch (Exception e) {

			if (tx != null) {
				tx.rollback();
			}
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return false;
	}

	public Double getThisMonthExpenses(String email) {
		Session session = HibernateSessionFactory.getSession();
		Double result = 0.0;

		try {

			String sql = "SELECT SUM(t.amount) FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email " + "AND t.typ = 'expenses' "
					+ "AND t.transaction_date >= date_trunc('month', CURRENT_DATE) "
					+ "AND t.transaction_date < date_trunc('month', CURRENT_DATE + INTERVAL '1 month')";
			Query query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object obj = query.uniqueResult();

			if (obj != null) {
				result = ((Number) obj).doubleValue();
			} else {
				result = 0.0;
			}
		} finally {
			session.close();
		}

		return result;
	}

	public Double getLastMonthExpense(String email) {
		Session session = HibernateSessionFactory.getSession();
		Double result = 0.0;

		try {
			String hql = "select sum(t.amount) from Transactions t " + "where t.users.email = :email "
					+ "and t.typ = 'expenses' " + "and month(t.transactionDate) = month(current_date()) - 1 "
					+ "and year(t.transactionDate) = year(current_date())";
			Query query = session.createQuery(hql);
			query.setParameter("email", email);

			result = (Double) query.uniqueResult();
			if (result == null)
				result = 0.0;

		} finally {
			session.close();
		}

		return result;
	}

	public Double getThisYearExpense(String email) {
		Session session = HibernateSessionFactory.getSession();
		Double result = 0.0;

		try {

			String sql = "SELECT SUM(t.amount) FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email " + "AND t.typ = 'expenses' "
					+ "AND t.transaction_date >= date_trunc('year', CURRENT_DATE) "
					+ "AND t.transaction_date < date_trunc('year', CURRENT_DATE + INTERVAL '1 year')";

			Query query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object obj = query.uniqueResult();

			if (obj != null) {
				result = ((Number) obj).doubleValue();
			}

		} finally {
			session.close();
		}

		return result;
	}

	public Double getThisMonthIncome(String email) {
		Session session = HibernateSessionFactory.getSession();
		Double result = 0.0;

		try {

			String sql = "SELECT SUM(t.amount) FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email " + "AND t.typ = 'income' "
					+ "AND t.transaction_date >= date_trunc('month', CURRENT_DATE) "
					+ "AND t.transaction_date < date_trunc('month', CURRENT_DATE + INTERVAL '1 month')";
			Query query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object obj = query.uniqueResult();

			if (obj != null) {
				result = ((Number) obj).doubleValue();
			} else {
				result = 0.0;
			}
		} finally {
			session.close();
		}

		return result;
	}

	public Double getLastMonthIncome(String email) {
		Session session = HibernateSessionFactory.getSession();
		Double result = 0.0;

		try {
			String hql = "select sum(t.amount) from Transactions t " + "where t.users.email = :email "
					+ "and t.typ = 'income' " + "and month(t.transactionDate) = month(current_date()) - 1 "
					+ "and year(t.transactionDate) = year(current_date())";
			Query query = session.createQuery(hql);
			query.setParameter("email", email);

			result = (Double) query.uniqueResult();
			if (result == null)
				result = 0.0;

		} finally {
			session.close();
		}

		return result;
	}

	public Double getThisYearIncome(String email) {
		Session session = HibernateSessionFactory.getSession();
		Double result = 0.0;

		try {

			String sql = "SELECT SUM(t.amount) FROM transactions t " + "JOIN users u ON t.user_id = u.id "
					+ "WHERE u.email = :email " + "AND t.typ = 'income' "
					+ "AND t.transaction_date >= date_trunc('year', CURRENT_DATE) "
					+ "AND t.transaction_date < date_trunc('year', CURRENT_DATE + INTERVAL '1 year')";

			Query query = session.createSQLQuery(sql);
			query.setParameter("email", email);

			Object obj = query.uniqueResult();

			if (obj != null) {
				result = ((Number) obj).doubleValue();
			}

		} finally {
			session.close();
		}

		return result;
	}

	public List<Object[]> getIncomeForExport(String email) {
		Session session = null;
		List<Object[]> list = new ArrayList<Object[]>();

		try {
			session = HibernateSessionFactory.getSession();
			String hql = "select c.categoriename, c.typ, t.transactionDate, t.description, t.amount "
					+ "from Transactions t " + "join t.categories c " + "join t.users u " + "where u.email = :email "
					+ "and lower(t.typ) = 'income' " + "order by t.transactionDate desc";
			Query query = session.createQuery(hql);
			query.setParameter("email", email);
			list = query.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return list;

	}

	public List<Object[]> getExpenseForExport(String email) {
		Session session = null;
		List<Object[]> list = new ArrayList<Object[]>();

		try {
			session = HibernateSessionFactory.getSession();
			String hql = "select c.categoriename, c.typ, t.transactionDate, t.description, t.amount "
					+ "from Transactions t " + "join t.categories c " + "join t.users u " + "where u.email = :email "
					+ "and lower(t.typ) = 'expenses' " + "order by t.transactionDate desc";
			Query query = session.createQuery(hql);
			query.setParameter("email", email);
			list = query.list();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}

		return list;

	}

	public void deleteExpense(int id) {
		Session session = HibernateSessionFactory.getSession();
		Transaction tx = session.beginTransaction();
		try {
			String hql = "delete from Transactions where id = :id";
			Query query = session.createQuery(hql);
			query.setParameter("id", id);
			query.executeUpdate();
			tx.commit();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		} finally {
			session.close();
		}
	}
}
