<template>
  <div class="my-orders">
    <el-card>
      <template #header>
        <h2>我的订单</h2>
      </template>
      <el-table :data="orders" stripe>
        <el-table-column prop="orderNo" label="订单编号" width="180" />
        <el-table-column label="房屋信息">
          <template #default="{ row }">
            {{ getHouseTitle(row.houseId) }}
          </template>
        </el-table-column>
        <el-table-column prop="startDate" label="起租日期" width="120" />
        <el-table-column prop="endDate" label="结束日期" width="120" />
        <el-table-column prop="totalAmount" label="总金额">
          <template #default="{ row }">
            ¥{{ row.totalAmount }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="getStatusType(row.status)">
              {{ getStatusText(row.status) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button 
              v-if="row.status === 0" 
              type="primary" 
              size="small" 
              @click="confirmOrder(row.id)"
            >
              确认
            </el-button>
            <el-button 
              v-if="row.status < 2" 
              type="danger" 
              size="small" 
              @click="cancelOrder(row.id)"
            >
              取消
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import request from '../utils/request'

export default {
  name: 'MyOrders',
  data() {
    return {
      orders: [],
      houses: {}
    }
  },
  created() {
    this.loadOrders()
  },
  methods: {
    async loadOrders() {
      const user = JSON.parse(localStorage.getItem('user'))
      let url = '/order/list'
      if (user.role === 'tenant') {
        url = `/order/tenant/${user.id}`
      } else if (user.role === 'landlord') {
        url = `/order/landlord/${user.id}`
      }
      const res = await request.get(url)
      this.orders = res.data
      this.loadHouseInfo()
    },
    async loadHouseInfo() {
      const houseIds = [...new Set(this.orders.map(o => o.houseId))]
      for (const id of houseIds) {
        const res = await request.get(`/house/${id}`)
        this.houses[id] = res.data
      }
    },
    getHouseTitle(houseId) {
      return this.houses[houseId]?.title || '加载中...'
    },
    getStatusText(status) {
      const texts = ['待确认', '已确认', '进行中', '已完成', '已取消']
      return texts[status] || '未知'
    },
    getStatusType(status) {
      const types = ['warning', 'primary', 'success', 'info', 'danger']
      return types[status] || 'info'
    },
    async confirmOrder(id) {
      await request.put(`/order/confirm/${id}`)
      this.$message.success('确认成功')
      this.loadOrders()
    },
    async cancelOrder(id) {
      await this.$confirm('确定取消该订单吗？')
      await request.put(`/order/cancel/${id}`)
      this.$message.success('取消成功')
      this.loadOrders()
    }
  }
}
</script>

<style scoped>
.my-orders {
  max-width: 1200px;
  margin: 0 auto;
}
</style>
