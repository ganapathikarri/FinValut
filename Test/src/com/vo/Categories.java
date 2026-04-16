package com.vo;

import java.util.HashSet;
import java.util.Set;


/**
 * Categories entity. @author MyEclipse Persistence Tools
 */

public class Categories  implements java.io.Serializable {


    // Fields    

     private Integer id;
     private Users users;
     private String categoriename;
     private String typ;
     private Set transactionses = new HashSet(0);


    // Constructors

    /** default constructor */
    public Categories() {
    }

	/** minimal constructor */
    public Categories(Integer id, String categoriename, String typ) {
        this.id = id;
        this.categoriename = categoriename;
        this.typ = typ;
    }
    
    /** full constructor */
    public Categories(Integer id, Users users, String categoriename, String typ, Set transactionses) {
        this.id = id;
        this.users = users;
        this.categoriename = categoriename;
        this.typ = typ;
        this.transactionses = transactionses;
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

    public String getCategoriename() {
        return this.categoriename;
    }
    
    public void setCategoriename(String categoriename) {
        this.categoriename = categoriename;
    }

    public String getTyp() {
        return this.typ;
    }
    
    public void setTyp(String typ) {
        this.typ = typ;
    }

    public Set getTransactionses() {
        return this.transactionses;
    }
    
    public void setTransactionses(Set transactionses) {
        this.transactionses = transactionses;
    }
   








}