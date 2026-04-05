package com.rental.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.rental.common.Result;
import com.rental.entity.House;
import com.rental.service.HouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/house")
@CrossOrigin
public class HouseController {

    @Autowired
    private HouseService houseService;

    @GetMapping("/list")
    public Result<List<House>> list() {
        LambdaQueryWrapper<House> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(House::getStatus, 1);
        return Result.success(houseService.list(wrapper));
    }

    @GetMapping("/page")
    public Result<Page<House>> page(@RequestParam(defaultValue = "1") Integer current,
                                     @RequestParam(defaultValue = "10") Integer size) {
        Page<House> page = new Page<>(current, size);
        LambdaQueryWrapper<House> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(House::getStatus, 1);
        return Result.success(houseService.page(page, wrapper));
    }

    @GetMapping("/{id}")
    public Result<House> getById(@PathVariable Long id) {
        House house = houseService.getById(id);
        if (house != null) {
            return Result.success(house);
        }
        return Result.error("房屋不存在");
    }

    @GetMapping("/search")
    public Result<List<House>> search(@RequestParam String keyword) {
        return Result.success(houseService.searchByKeyword(keyword));
    }

    @GetMapping("/landlord/{landlordId}")
    public Result<List<House>> getByLandlordId(@PathVariable Long landlordId) {
        return Result.success(houseService.getByLandlordId(landlordId));
    }

    @PostMapping
    public Result<String> save(@RequestBody House house) {
        house.setStatus(1);
        if (houseService.save(house)) {
            return Result.success("添加成功");
        }
        return Result.error("添加失败");
    }

    @PutMapping
    public Result<String> update(@RequestBody House house) {
        if (houseService.updateById(house)) {
            return Result.success("更新成功");
        }
        return Result.error("更新失败");
    }

    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id) {
        House house = new House();
        house.setId(id);
        house.setStatus(0);
        if (houseService.updateById(house)) {
            return Result.success("删除成功");
        }
        return Result.error("删除失败");
    }
}
