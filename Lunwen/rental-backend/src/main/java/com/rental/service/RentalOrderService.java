package com.rental.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.rental.entity.RentalOrder;

public interface RentalOrderService extends IService<RentalOrder> {
    String generateOrderNo();
}
