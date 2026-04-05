<template>
  <div id="app">
    <el-container>
      <el-header>
        <div class="header-content">
          <h1 @click="goHome" style="cursor: pointer;">小区租房系统</h1>
          <div class="user-info" v-if="user">
            <el-dropdown trigger="click" @command="handleCommand">
              <span class="user-dropdown">
                <el-avatar :size="32" :icon="UserFilled" />
                <span class="username">{{ user.realName || user.username }}</span>
                <el-tag size="small" :type="getRoleType(user.role)">{{ getRoleName(user.role) }}</el-tag>
              </span>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">
                    <el-icon><User /></el-icon>
                    个人中心
                  </el-dropdown-item>
                  <el-dropdown-item command="orders" v-if="user.role === 'tenant'">
                    <el-icon><Document /></el-icon>
                    我的订单
                  </el-dropdown-item>
                  <el-dropdown-item command="houses" v-if="user.role === 'landlord'">
                    <el-icon><House /></el-icon>
                    我的房源
                  </el-dropdown-item>
                  <el-dropdown-item divided command="logout">
                    <el-icon><SwitchButton /></el-icon>
                    退出登录
                  </el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
          <div v-else class="auth-buttons">
            <router-link to="/login">
              <el-button type="primary" size="small">登录</el-button>
            </router-link>
            <router-link to="/register">
              <el-button type="success" size="small" style="margin-left: 10px;">注册</el-button>
            </router-link>
          </div>
        </div>
      </el-header>
      <el-main>
        <router-view @login-success="refreshUser"></router-view>
      </el-main>
    </el-container>
  </div>
</template>

<script>
import { UserFilled, User, Document, House, SwitchButton } from '@element-plus/icons-vue'

export default {
  name: 'App',
  components: { UserFilled, User, Document, House, SwitchButton },
  data() {
    return {
      user: null
    }
  },
  created() {
    this.loadUser()
  },
  methods: {
    loadUser() {
      const userStr = localStorage.getItem('user')
      this.user = userStr ? JSON.parse(userStr) : null
    },
    refreshUser() {
      this.loadUser()
    },
    handleCommand(command) {
      switch (command) {
        case 'profile':
          this.$router.push('/profile')
          break
        case 'orders':
          this.$router.push('/my-orders')
          break
        case 'houses':
          this.$router.push('/my-houses')
          break
        case 'logout':
          this.logout()
          break
      }
    },
    logout() {
      this.$confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        localStorage.removeItem('user')
        this.user = null
        this.$message.success('已退出登录')
        this.$router.push('/home')
      }).catch(() => {})
    },
    goHome() {
      this.$router.push('/home')
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
    }
  },
  watch: {
    '$route'() {
      this.loadUser()
    }
  }
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

#app {
  font-family: Arial, sans-serif;
  min-height: 100vh;
}

.el-header {
  background-color: #409EFF;
  color: white;
  padding: 0 20px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
}

.header-content h1 {
  font-size: 24px;
}

.user-info {
  display: flex;
  align-items: center;
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 10px;
  cursor: pointer;
  padding: 5px 15px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.user-dropdown:hover {
  background-color: rgba(255, 255, 255, 0.1);
}

.username {
  font-size: 14px;
}

.auth-buttons {
  display: flex;
  align-items: center;
}

.el-main {
  padding: 20px;
  background-color: #f5f5f5;
  min-height: calc(100vh - 60px);
}
</style>
