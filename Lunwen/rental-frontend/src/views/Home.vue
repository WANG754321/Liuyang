<template>
  <div class="home">
    <div class="search-bar">
      <el-input v-model="keyword" placeholder="搜索房屋" style="width: 300px" />
      <el-button type="primary" @click="search">搜索</el-button>
      <el-button @click="loadHouses">重置</el-button>
    </div>
    
    <div class="nav-buttons">
      <template v-if="user">
        <el-button type="primary" @click="$router.push('/my-houses')">我的房源</el-button>
        <el-button type="success" @click="$router.push('/my-orders')">我的订单</el-button>
      </template>
      <template v-else>
        <el-alert
          title="您还未登录"
          type="info"
          description="登录后可进行预约看房等操作"
          show-icon
          :closable="false"
          style="margin-bottom: 15px;"
        >
          <template #default>
            <span>您还未登录，</span>
            <el-button type="primary" size="small" text @click="$router.push('/login')">立即登录</el-button>
            <span>或</span>
            <el-button type="success" size="small" text @click="$router.push('/register')">注册账号</el-button>
          </template>
        </el-alert>
      </template>
    </div>

    <div class="house-list">
      <el-row :gutter="20">
        <el-col :span="8" v-for="house in houses" :key="house.id">
          <el-card class="house-card" @click="goDetail(house.id)">
            <div class="house-image">
              <img v-if="house.imageUrl" :src="house.imageUrl" :alt="house.title" @error="handleImageError" />
              <el-icon v-else :size="60"><House /></el-icon>
            </div>
            <div class="house-info">
              <h3>{{ house.title }}</h3>
              <p class="address">{{ house.address }}</p>
              <p class="price">¥{{ house.price }}/月</p>
              <p class="detail">{{ house.roomCount }}室{{ house.hallCount }}厅 | {{ house.area }}㎡</p>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import request from '../utils/request'
import { House } from '@element-plus/icons-vue'

export default {
  name: 'Home',
  components: { House },
  data() {
    return {
      keyword: '',
      houses: [],
      user: null
    }
  },
  created() {
    this.loadHouses()
    this.loadUser()
  },
  methods: {
    loadUser() {
      const userStr = localStorage.getItem('user')
      this.user = userStr ? JSON.parse(userStr) : null
    },
    async loadHouses() {
      const res = await request.get('/house/list')
      this.houses = res.data
    },
    async search() {
      if (this.keyword) {
        const res = await request.get('/house/search', { params: { keyword: this.keyword } })
        this.houses = res.data
      } else {
        this.loadHouses()
      }
    },
    goDetail(id) {
      this.$router.push(`/house/${id}`)
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
.home {
  height: calc(100vh - 100px);
  overflow-y: auto;
  padding-right: 10px;
}

.home::-webkit-scrollbar {
  width: 8px;
}

.home::-webkit-scrollbar-track {
  background: #f1f1f1;
  border-radius: 4px;
}

.home::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 4px;
}

.home::-webkit-scrollbar-thumb:hover {
  background: #a8a8a8;
}

.search-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
  position: sticky;
  top: 0;
  background: #f5f5f5;
  padding: 10px 0;
  z-index: 10;
}

.nav-buttons {
  margin-bottom: 20px;
}

.house-card {
  cursor: pointer;
  transition: all 0.3s;
  margin-bottom: 20px;
}

.house-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.house-image {
  height: 180px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f5f5;
  border-radius: 4px;
  overflow: hidden;
}

.house-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.house-info h3 {
  margin: 10px 0;
  font-size: 16px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.house-info .address {
  color: #999;
  font-size: 12px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.house-info .price {
  color: #f56c6c;
  font-size: 18px;
  font-weight: bold;
  margin: 10px 0;
}

.house-info .detail {
  color: #666;
  font-size: 12px;
}
</style>
