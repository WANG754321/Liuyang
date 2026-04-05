<template>
  <div class="profile">
    <el-row :gutter="20">
      <el-col :span="8">
        <el-card class="user-card">
          <div class="avatar">
            <el-avatar :size="100" :icon="UserFilled" />
          </div>
          <h2>{{ user?.realName || user?.username }}</h2>
          <el-tag :type="getRoleType(user?.role)" size="large">{{ getRoleName(user?.role) }}</el-tag>
          <div class="user-stats">
            <div class="stat-item">
              <div class="stat-value">{{ stats.houseCount }}</div>
              <div class="stat-label">收藏房源</div>
            </div>
            <div class="stat-item">
              <div class="stat-value">{{ stats.orderCount }}</div>
              <div class="stat-label">预约订单</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :span="16">
        <el-card>
          <el-tabs v-model="activeTab">
            <el-tab-pane label="个人信息" name="info">
              <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
                <el-form-item label="用户名">
                  <el-input v-model="form.username" disabled />
                </el-form-item>
                <el-form-item label="真实姓名" prop="realName">
                  <el-input v-model="form.realName" placeholder="请输入真实姓名" />
                </el-form-item>
                <el-form-item label="手机号" prop="phone">
                  <el-input v-model="form.phone" placeholder="请输入手机号" />
                </el-form-item>
                <el-form-item label="邮箱" prop="email">
                  <el-input v-model="form.email" placeholder="请输入邮箱" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="updateInfo">保存修改</el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
            
            <el-tab-pane label="修改密码" name="password">
              <el-form :model="passwordForm" :rules="passwordRules" ref="passwordFormRef" label-width="100px">
                <el-form-item label="当前密码" prop="oldPassword">
                  <el-input v-model="passwordForm.oldPassword" type="password" placeholder="请输入当前密码" />
                </el-form-item>
                <el-form-item label="新密码" prop="newPassword">
                  <el-input v-model="passwordForm.newPassword" type="password" placeholder="请输入新密码" />
                </el-form-item>
                <el-form-item label="确认新密码" prop="confirmPassword">
                  <el-input v-model="passwordForm.confirmPassword" type="password" placeholder="请再次输入新密码" />
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="updatePassword">修改密码</el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
            
            <el-tab-pane label="我的订单" name="orders" v-if="user?.role === 'tenant'">
              <el-table :data="orders" stripe>
                <el-table-column prop="orderNo" label="订单编号" width="180" />
                <el-table-column label="房屋" width="200">
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
              </el-table>
            </el-tab-pane>
            
            <el-tab-pane label="我的房源" name="houses" v-if="user?.role === 'landlord'">
              <el-table :data="houses" stripe>
                <el-table-column prop="title" label="标题" />
                <el-table-column prop="address" label="地址" />
                <el-table-column prop="price" label="租金">
                  <template #default="{ row }">
                    ¥{{ row.price }}/月
                  </template>
                </el-table-column>
                <el-table-column prop="status" label="状态">
                  <template #default="{ row }">
                    <el-tag :type="row.status === 1 ? 'success' : 'info'">
                      {{ row.status === 1 ? '上架' : row.status === 2 ? '已租' : '下架' }}
                    </el-tag>
                  </template>
                </el-table-column>
              </el-table>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import request from '../utils/request'
import { UserFilled } from '@element-plus/icons-vue'

export default {
  name: 'Profile',
  components: { UserFilled },
  data() {
    const validatePass = (rule, value, callback) => {
      if (value !== this.passwordForm.newPassword) {
        callback(new Error('两次输入密码不一致'))
      } else {
        callback()
      }
    }
    return {
      UserFilled,
      user: null,
      activeTab: 'info',
      stats: {
        houseCount: 0,
        orderCount: 0
      },
      form: {
        username: '',
        realName: '',
        phone: '',
        email: ''
      },
      rules: {
        realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
        phone: [{ required: true, message: '请输入手机号', trigger: 'blur' }]
      },
      passwordForm: {
        oldPassword: '',
        newPassword: '',
        confirmPassword: ''
      },
      passwordRules: {
        oldPassword: [{ required: true, message: '请输入当前密码', trigger: 'blur' }],
        newPassword: [{ required: true, min: 6, message: '密码至少6位', trigger: 'blur' }],
        confirmPassword: [{ required: true, validator: validatePass, trigger: 'blur' }]
      },
      orders: [],
      houses: [],
      houseMap: {}
    }
  },
  created() {
    this.loadUser()
    this.loadStats()
  },
  methods: {
    loadUser() {
      const userStr = localStorage.getItem('user')
      if (userStr) {
        this.user = JSON.parse(userStr)
        this.form = {
          username: this.user.username,
          realName: this.user.realName || '',
          phone: this.user.phone || '',
          email: this.user.email || ''
        }
        if (this.user.role === 'tenant') {
          this.loadOrders()
        }
        if (this.user.role === 'landlord') {
          this.loadHouses()
        }
      }
    },
    async loadStats() {
      if (this.user?.role === 'tenant') {
        const res = await request.get(`/order/tenant/${this.user.id}`)
        this.stats.orderCount = res.data?.length || 0
      }
      if (this.user?.role === 'landlord') {
        const res = await request.get(`/house/landlord/${this.user.id}`)
        this.stats.houseCount = res.data?.length || 0
      }
    },
    async loadOrders() {
      const res = await request.get(`/order/tenant/${this.user.id}`)
      this.orders = res.data || []
      this.loadHouseInfo()
    },
    async loadHouses() {
      const res = await request.get(`/house/landlord/${this.user.id}`)
      this.houses = res.data || []
    },
    async loadHouseInfo() {
      const houseIds = [...new Set(this.orders.map(o => o.houseId))]
      for (const id of houseIds) {
        const res = await request.get(`/house/${id}`)
        this.houseMap[id] = res.data
      }
    },
    getHouseTitle(houseId) {
      return this.houseMap[houseId]?.title || '加载中...'
    },
    getStatusText(status) {
      const texts = ['待确认', '已确认', '进行中', '已完成', '已取消']
      return texts[status] || '未知'
    },
    getStatusType(status) {
      const types = ['warning', 'primary', 'success', 'info', 'danger']
      return types[status] || 'info'
    },
    getRoleName(role) {
      const roles = {
        admin: '管理员',
        landlord: '房东',
        tenant: '租客'
      }
      return roles[role] || '用户'
    },
    getRoleType(role) {
      const types = {
        admin: 'danger',
        landlord: 'warning',
        tenant: 'success'
      }
      return types[role] || 'info'
    },
    async updateInfo() {
      this.$refs.formRef.validate(async (valid) => {
        if (valid) {
          const data = {
            id: this.user.id,
            realName: this.form.realName,
            phone: this.form.phone,
            email: this.form.email
          }
          await request.put('/user', data)
          this.user.realName = this.form.realName
          this.user.phone = this.form.phone
          this.user.email = this.form.email
          localStorage.setItem('user', JSON.stringify(this.user))
          this.$message.success('修改成功')
        }
      })
    },
    async updatePassword() {
      this.$refs.passwordFormRef.validate(async (valid) => {
        if (valid) {
          if (this.passwordForm.oldPassword !== this.user.password) {
            this.$message.error('当前密码错误')
            return
          }
          const data = {
            id: this.user.id,
            password: this.passwordForm.newPassword
          }
          await request.put('/user', data)
          this.user.password = this.passwordForm.newPassword
          localStorage.setItem('user', JSON.stringify(this.user))
          this.$message.success('密码修改成功')
          this.passwordForm = {
            oldPassword: '',
            newPassword: '',
            confirmPassword: ''
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.profile {
  max-width: 1200px;
  margin: 0 auto;
  height: calc(100vh - 100px);
  overflow-y: auto;
}

.profile::-webkit-scrollbar {
  width: 8px;
}

.profile::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.profile::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

.user-card {
  text-align: center;
  padding: 20px;
}

.avatar {
  margin-bottom: 20px;
}

.user-card h2 {
  margin: 10px 0;
}

.user-stats {
  display: flex;
  justify-content: space-around;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #409EFF;
}

.stat-label {
  font-size: 14px;
  color: #999;
  margin-top: 5px;
}
</style>
