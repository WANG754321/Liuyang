package com.rental.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.rental.common.Result;
import com.rental.entity.House;
import com.rental.entity.RentalOrder;
import com.rental.service.HouseService;
import com.rental.service.RentalOrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.time.temporal.ChronoUnit;
import java.util.List;

@RestController
@RequestMapping("/api/order")
@CrossOrigin
public class RentalOrderController {

    @Autowired
    private RentalOrderService orderService;

    @Autowired
    private HouseService houseService;

    @GetMapping("/list")
    public Result<List<RentalOrder>> list() {
        return Result.success(orderService.list());
    }

    @GetMapping("/page")
    public Result<Page<RentalOrder>> page(@RequestParam(defaultValue = "1") Integer current,
                                           @RequestParam(defaultValue = "10") Integer size) {
        Page<RentalOrder> page = new Page<>(current, size);
        return Result.success(orderService.page(page));
    }

    @GetMapping("/{id}")
    public Result<RentalOrder> getById(@PathVariable Long id) {
        RentalOrder order = orderService.getById(id);
        if (order != null) {
            return Result.success(order);
        }
        return Result.error("订单不存在");
    }

    @GetMapping("/tenant/{tenantId}")
    public Result<List<RentalOrder>> getByTenantId(@PathVariable Long tenantId) {
        LambdaQueryWrapper<RentalOrder> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RentalOrder::getTenantId, tenantId);
        return Result.success(orderService.list(wrapper));
    }

    @GetMapping("/landlord/{landlordId}")
    public Result<List<RentalOrder>> getByLandlordId(@PathVariable Long landlordId) {
        LambdaQueryWrapper<RentalOrder> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(RentalOrder::getLandlordId, landlordId);
        return Result.success(orderService.list(wrapper));
    }

    @PostMapping
    public Result<String> save(@RequestBody RentalOrder order) {
        House house = houseService.getById(order.getHouseId());
        if (house == null) {
            return Result.error("房屋不存在");
        }
        if (house.getStatus() != 1) {
            return Result.error("房屋不可租");
        }
        order.setOrderNo(orderService.generateOrderNo());
        order.setLandlordId(house.getLandlordId());
        order.setMonthlyRent(house.getPrice());
        order.setDeposit(house.getPrice());
        long months = ChronoUnit.MONTHS.between(order.getStartDate(), order.getEndDate());
        if (months <= 0) {
            months = 1;
        }
        order.setTotalAmount(house.getPrice().multiply(new BigDecimal(months)).add(order.getDeposit()));
        order.setStatus(0);
        if (orderService.save(order)) {
            house.setStatus(2);
            houseService.updateById(house);
            return Result.success("预约成功");
        }
        return Result.error("预约失败");
    }

    @PutMapping("/confirm/{id}")
    public Result<String> confirm(@PathVariable Long id) {
        RentalOrder order = orderService.getById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        order.setStatus(1);
        if (orderService.updateById(order)) {
            return Result.success("确认成功");
        }
        return Result.error("确认失败");
    }

    @PutMapping("/cancel/{id}")
    public Result<String> cancel(@PathVariable Long id) {
        RentalOrder order = orderService.getById(id);
        if (order == null) {
            return Result.error("订单不存在");
        }
        order.setStatus(4);
        House house = houseService.getById(order.getHouseId());
        if (house != null) {
            house.setStatus(1);
            houseService.updateById(house);
        }
        if (orderService.updateById(order)) {
            return Result.success("取消成功");
        }
        return Result.error("取消失败");
    }
}
