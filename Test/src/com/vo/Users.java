package com.vo;

import java.sql.Timestamp;
import java.util.HashSet;
import java.util.Set;

/**
 * Users entity. @author MyEclipse Persistence Tools
 */

public class Users implements java.io.Serializable {

	// Fields

	private Integer id;
	private String username;
	private String email;
	private String userpass;
	private Timestamp createdAt;
	private String firstName;
	private String phone;
	private String currency;
	private Integer monthlyIncome;
	private Set categorieses = new HashSet(0);
	private Set transactionses = new HashSet(0);

	// Constructors

	/** default constructor */
	public Users() {
	}

	/** minimal constructor */
	public Users(Integer id, String username, String email, String userpass) {
		this.id = id;
		this.username = username;
		this.email = email;
		this.userpass = userpass;
	}

	/** full constructor */
	public Users(Integer id, String username, String email, String userpass, Timestamp createdAt, String firstName,
			String phone, String currency, Integer monthlyIncome, Set categorieses, Set transactionses) {
		this.id = id;
		this.username = username;
		this.email = email;
		this.userpass = userpass;
		this.createdAt = createdAt;
		this.firstName = firstName;
		this.phone = phone;
		this.currency = currency;
		this.monthlyIncome = monthlyIncome;
		this.categorieses = categorieses;
		this.transactionses = transactionses;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUsername() {
		return this.username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUserpass() {
		return this.userpass;
	}

	public void setUserpass(String userpass) {
		this.userpass = userpass;
	}

	public Timestamp getCreatedAt() {
		return this.createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public String getFirstName() {
		return this.firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getPhone() {
		return this.phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getCurrency() {
		return this.currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

	public Integer getMonthlyIncome() {
		return this.monthlyIncome;
	}

	public void setMonthlyIncome(Integer monthlyIncome) {
		this.monthlyIncome = monthlyIncome;
	}

	public Set getCategorieses() {
		return this.categorieses;
	}

	public void setCategorieses(Set categorieses) {
		this.categorieses = categorieses;
	}

	public Set getTransactionses() {
		return this.transactionses;
	}

	public void setTransactionses(Set transactionses) {
		this.transactionses = transactionses;
	}

}