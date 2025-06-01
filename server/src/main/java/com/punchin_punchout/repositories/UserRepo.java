package com.punchin_punchout.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.punchin_punchout.entities.UserEntity;

public interface UserRepo extends JpaRepository<UserEntity,String> {


    UserEntity findByUsername(String username);
    
}
