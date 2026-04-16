package com.vo;

import java.sql.Timestamp;

/**
 * Transactions entity. @author MyEclipse Persistence Tools
 */

public class Transactions implements java.io.Serializable {

	// Fields

	private Integer id;
	private Users users;
	private Categories categories;
	private Double amount;
	private String typ;
	private String description;
	private Timestamp transactionDate;

	// Constructors

	/** default constructor */
	public Transactions() {
	}

	/** minimal constructor */
	public Transactions(Integer id, Users users, Categories categories, Double amount, String typ) {
		this.id = id;
		this.users = users;
		this.categories = categories;
		this.amount = amount;
		this.typ = typ;
	}

	/** full constructor */
	public Transactions(Integer id, Users users, Categories categories, Double amount, String typ, String description,
			Timestamp transactionDate) {
		this.id = id;
		this.users = users;
		this.categories = categories;
		this.amount = amount;
		this.typ = typ;
		this.description = description;
		this.transactionDate = transactionDate;
	}

	// Property accessors

	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Users getUsers() {
		return this.users;
	}

	public void setUsers(Users users) {
		this.users = users;
	}

	public Categories getCategories() {
		return this.categories;
	}

	public void setCategories(Categories categories) {
		this.categories = categories;
	}

	public Double getAmount() {
		return this.amount;
	}

	public void setAmount(Double amount) {
		this.amount = amount;
	}

	public String getTyp() {
		return this.typ;
	}

	public void setTyp(String typ) {
		this.typ = typ;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Timestamp getTransactionDate() {
		return this.transactionDate;
	}

	public void setTransactionDate(Timestamp transactionDate) {
		this.transactionDate = transactionDate;
	}

}