package com.rental.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("house")
public class House {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String title;
    private String address;
    private BigDecimal area;
    private BigDecimal price;
    private Integer roomCount;
    private Integer hallCount;
    private String floor;
    private String orientation;
    private String decoration;
    private String facilities;
    private String description;
    private String imageUrl;
    private Long landlordId;
    private Integer status;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
