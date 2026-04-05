<template>
  <div class="house-detail">
    <el-card v-if="house">
      <template #header>
        <div class="header">
          <h2>{{ house.title }}</h2>
          <el-tag :type="house.status === 1 ? 'success' : house.status === 2 ? 'warning' : 'info'">
            {{ house.status === 1 ? '可租' : house.status === 2 ? '已租' : '下架' }}
          </el-tag>
        </div>
      </template>
      <el-row :gutter="30">
        <el-col :span="14">
          <div class="house-image">
            <img v-if="house.imageUrl" :src="house.imageUrl" :alt="house.title" @error="handleImageError" />
            <el-icon v-else :size="120"><House /></el-icon>
          </div>
        </el-col>
        <el-col :span="10">
          <div class="house-info">
            <div class="price-section">
              <span class="price">¥{{ house.price }}</span>
              <span class="unit">/月</span>
            </div>
            <el-divider />
            <div class="info-item">
              <span class="label">地址：</span>
              <span class="value">{{ house.address }}</span>
            </div>
            <div class="info-item">
              <span class="label">面积：</span>
              <span class="value">{{ house.area }}㎡</span>
            </div>
            <div class="info-item">
              <span class="label">户型：</span>
              <span class="value">{{ house.roomCount }}室{{ house.hallCount }}厅</span>
            </div>
            <div class="info-item">
              <span class="label">楼层：</span>
              <span class="value">{{ house.floor }}</span>
            </div>
            <div class="info-item">
              <span class="label">朝向：</span>
              <span class="value">{{ house.orientation }}</span>
            </div>
            <div class="info-item">
              <span class="label">装修：</span>
              <span class="value">{{ house.decoration }}</span>
            </div>
            <div class="info-item">
              <span class="label">配套：</span>
              <span class="value">{{ house.facilities }}</span>
            </div>
            <el-divider />
            <div class="description">
              <div class="label">房屋描述：</div>
              <p>{{ house.description }}</p>
            </div>
          </div>
          <div class="actions">
            <template v-if="!user">
              <el-alert
                title="您还未登录"
                type="warning"
                description="登录后即可预约看房"
                show-icon
                :closable="false"
                style="margin-bottom: 15px;"
              />
              <el-button type="primary" size="large" @click="goLogin">登录后预约</el-button>
            </template>
            <template v-else-if="user.role === 'tenant'">
              <el-button type="primary" size="large" @click="showOrderDialog">立即预约</el-button>
            </template>
            <template v-else-if="user.role === 'landlord'">
              <el-tag type="info" size="large">您是房东，无法预约房源</el-tag>
            </template>
            <template v-else>
              <el-tag type="info" size="large">管理员无法预约房源</el-tag>
            </template>
          </div>
        </el-col>
      </el-row>
    </el-card>

    <el-dialog v-model="orderDialogVisible" title="预约看房" width="500px">
      <el-form :model="orderForm" :rules="orderRules" ref="orderFormRef" label-width="80px">
        <el-form-item label="起租日期" prop="startDate">
          <el-date-picker v-model="orderForm.startDate" type="date" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
        <el-form-item label="结束日期" prop="endDate">
          <el-date-picker v-model="orderForm.endDate" type="date" placeholder="选择日期" style="width: 100%" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="orderDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitOrder">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import request from '../utils/request'
import { House } from '@element-plus/icons-vue'

export default {
  name: 'HouseDetail',
  components: { House },
  data() {
    return {
      house: null,
      user: null,
      orderDialogVisible: false,
      orderForm: {
        startDate: '',
        endDate: ''
      },
      orderRules: {
        startDate: [{ required: true, message: '请选择起租日期', trigger: 'change' }],
        endDate: [{ required: true, message: '请选择结束日期', trigger: 'change' }]
      }
    }
  },
  created() {
    this.loadHouse()
    this.loadUser()
  },
  methods: {
    loadUser() {
      const userStr = localStorage.getItem('user')
      this.user = userStr ? JSON.parse(userStr) : null
    },
    async loadHouse() {
      const res = await request.get(`/house/${this.$route.params.id}`)
      this.house = res.data
    },
    showOrderDialog() {
      this.orderDialogVisible = true
    },
    goLogin() {
      this.$confirm('预约看房需要登录，是否立即登录？', '提示', {
        confirmButtonText: '去登录',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$router.push('/login')
      }).catch(() => {})
    },
    submitOrder() {
      this.$refs.orderFormRef.validate(async (valid) => {
        if (valid) {
          const data = {
            houseId: this.house.id,
            tenantId: this.user.id,
            startDate: this.orderForm.startDate,
            endDate: this.orderForm.endDate
          }
          await request.post('/order', data)
          this.$message.success('预约成功')
          this.orderDialogVisible = false
          this.$router.push('/my-orders')
        }
      })
    },
    handleImageError(e) {
      e.target.style.display = 'none'
    }
  },
  watch: {
    '$route'() {
      this.loadUser()
    }
  }
}
</script>

<style scoped>
.house-detail {
  max-width: 1200px;
  margin: 0 auto;
  height: calc(100vh - 100px);
  overflow-y: auto;
  padding-right: 10px;
}

.house-detail::-webkit-scrollbar {
  width: 8px;
}

.house-detail::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.house-detail::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

.house-detail::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header h2 {
  margin: 0;
}

.house-image {
  height: 400px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f5f5;
  border-radius: 8px;
  overflow: hidden;
}

.house-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.house-info {
  padding: 10px 0;
}

.price-section {
  margin-bottom: 10px;
}

.price-section .price {
  color: #f56c6c;
  font-size: 32px;
  font-weight: bold;
}

.price-section .unit {
  color: #999;
  font-size: 14px;
}

.info-item {
  margin: 15px 0;
  display: flex;
  align-items: flex-start;
}

.info-item .label {
  color: #999;
  width: 60px;
  flex-shrink: 0;
}

.info-item .value {
  color: #333;
  flex: 1;
}

.description {
  margin-top: 10px;
}

.description .label {
  color: #999;
  margin-bottom: 10px;
}

.description p {
  color: #333;
  line-height: 1.8;
  margin: 0;
}

.actions {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}
</style>
