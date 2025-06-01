package com.punchin_punchout.entities;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "time_logs")
@Data
public class TimeLog {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    private String userId;

    @Column(nullable = true)
    private LocalDateTime punchIn;

    @Column(nullable = true)
    private LocalDateTime punchOut;

    private Long duration; // in minutes
}
