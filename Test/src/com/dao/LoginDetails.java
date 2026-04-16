package com.dao;

import java.util.ArrayList;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import com.vo.Users;

public class LoginDetails {
	public Users getByEmail(String email)
	{
		Session session = null;
		Users user = null;
		try {
			session=HibernateSessionFactory.getSession();
			String hql = "from Users where email =:email";
			Query query = session.createQuery(hql);
			query.setParameter("email", email);
			user=(Users) query.uniqueResult();
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally {
			if(session!=null && session.isOpen()) {
				session.close();
			}
		}
		
		return user;
	}
	public boolean isEmailExists(String email) {
	    Session session = null;
	    try {
	        session = HibernateSessionFactory.getSession();

	        String hql = "from Users where email = :email";
	        Query query = session.createQuery(hql);
	        query.setParameter("email", email);

	        List list = query.list();

	        return list.size() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null && session.isOpen()) {
	            session.close();
	        }
	    }
	    return false;
	}
	public Integer getMaxid()
	{
		Session session = null;
		Integer maxid=null;
		try {
			session=HibernateSessionFactory.getSession();
			Query query = session.createQuery("select max(id) from Users");
			maxid = (Integer) query.uniqueResult();
			if(maxid==null) {
				maxid=0;
			}
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally {
			if(session!=null && session.isOpen()) {
				session.close();
			}
		}
		
		return maxid;
	}
	
	public Users getUserListByEmail(String email)
	{
		Users user=null;
		Session session=null;
		try {
			session=HibernateSessionFactory.getSession();
			String hql = "select * from Users where email =:email";
			Query query = session.createQuery(hql);
			query.setParameter("email", email);
			user = (Users) query.uniqueResult();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}finally {
			if(session!=null && session.isOpen()) {
				session.close();
			}
		}
		
		return user;
	}

	public boolean saveUserDetails(Users user)
	{
		
		Session session = null;
		org.hibernate.Transaction tx=null;
		try {
			session = HibernateSessionFactory.getSession();
			tx=session.beginTransaction();
			session.saveOrUpdate(user);
			
			tx.commit();
			return true;
			
		} catch (Exception e) {
			// TODO: handle exception
			if (tx != null) {
	            tx.rollback(); // 🔥 rollback on error
	        }
			e.printStackTrace();
		}finally {
			if(session!=null && session.isOpen()) {
				session.close();
			}
		}
		
		return false;
	}
	
	public boolean fetchUserDetails(String username, String Password) {
		Session session = null;
		try {
			session = HibernateSessionFactory.getSession();
			String hql = "from Users where email =:username";
			Query query = session.createQuery(hql);
			query.setParameter("username", username);
			List<Users> list = new ArrayList<>();
			list = query.list();

			if (list.size()>0) {
				Users user = list.get(0);

				if(user.getUserpass().equals(Password)) {
				    return true;
				} else {
				    return false;
				}
			} else {
				return false;
			}

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		} finally {
			if (session != null && session.isOpen()) {
				session.close();
			}
		}
		return false;
	}
}
