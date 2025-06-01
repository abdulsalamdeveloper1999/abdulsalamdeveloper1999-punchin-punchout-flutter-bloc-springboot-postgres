package com.punchin_punchout.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;

import jakarta.persistence.Id;
import lombok.Data;

@Entity(name = "users")
@Data
public class UserEntity {

    @Id
    private String id;

    @Column(unique = true)
    private String username;

    private String password;

    

}
