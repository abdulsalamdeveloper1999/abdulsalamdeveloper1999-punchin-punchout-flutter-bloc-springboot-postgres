package com.punchin_punchout.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.punchin_punchout.entities.TimeLog;

public interface TimeLogRepo extends JpaRepository<TimeLog, Long> {

    // Return all time logs for a user
    List<TimeLog> findByUserId(String userId);

    // // Find the latest open punch-in (punchOut is null) for the user
    // Optional<TimeLog> findFirstByUserIdAndPunchOutIsNullOrderByPunchInDesc(String userId);



    // @Query("SELECT t FROM TimeLog t WHERE t.userId = :userId AND t.punchOut IS NULL")
    // Optional<TimeLog> findActivePunchIn(@Param("userId") String userId);

     // Option A: Custom Query
     @Query("SELECT t FROM TimeLog t WHERE t.userId = :userId AND t.punchOut IS NULL")
     Optional<TimeLog> findActivePunchIn(String userId);
 
     // Option B (alternative): Derived query (no need for @Query)
     // Optional<TimeLog> findByUserIdAndPunchOutIsNull(String userId);


      // Fix: Correct Spring Data method name
    Optional<TimeLog> findFirstByUserIdAndPunchOutIsNullOrderByPunchInDesc(String userId);

    
}
