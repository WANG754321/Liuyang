package com.rental.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.rental.entity.House;
import java.util.List;

public interface HouseService extends IService<House> {
    List<House> searchByKeyword(String keyword);
    List<House> getByLandlordId(Long landlordId);
}
