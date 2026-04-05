package com.rental.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.rental.entity.House;
import com.rental.mapper.HouseMapper;
import com.rental.service.HouseService;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class HouseServiceImpl extends ServiceImpl<HouseMapper, House> implements HouseService {

    @Override
    public List<House> searchByKeyword(String keyword) {
        LambdaQueryWrapper<House> wrapper = new LambdaQueryWrapper<>();
        wrapper.like(House::getTitle, keyword)
               .or().like(House::getAddress, keyword)
               .eq(House::getStatus, 1);
        return this.list(wrapper);
    }

    @Override
    public List<House> getByLandlordId(Long landlordId) {
        LambdaQueryWrapper<House> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(House::getLandlordId, landlordId);
        return this.list(wrapper);
    }
}
