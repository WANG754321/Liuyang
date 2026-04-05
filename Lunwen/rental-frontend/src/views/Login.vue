<template>
  <div class="login-container">
    <el-card class="login-card">
      <template #header>
        <h2>用户登录</h2>
      </template>
      <el-form :model="form" :rules="rules" ref="formRef">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="用户名" prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input v-model="form.password" type="password" placeholder="密码" prefix-icon="Lock" @keyup.enter="handleLogin" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" style="width: 100%" :loading="loading">登录</el-button>
        </el-form-item>
      </el-form>
      <div class="register-link">
        还没有账号？<router-link to="/register">立即注册</router-link>
      </div>
      <div class="demo-accounts">
        <el-divider>测试账号</el-divider>
        <p><strong>管理员：</strong>admin / admin123</p>
        <p><strong>房东：</strong>landlord1 / 123456</p>
        <p><strong>租客：</strong>tenant1 / 123456</p>
      </div>
    </el-card>
  </div>
</template>

<script>
import request from '../utils/request'

export default {
  name: 'Login',
  data() {
    return {
      form: {
        username: '',
        password: ''
      },
      rules: {
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
      },
      loading: false
    }
  },
  methods: {
    handleLogin() {
      this.$refs.formRef.validate(async (valid) => {
        if (valid) {
          this.loading = true
          try {
            const res = await request.post('/user/login', this.form)
            localStorage.setItem('user', JSON.stringify(res.data))
            this.$message.success('登录成功')
            this.$emit('login-success')
            const redirect = this.$route.query.redirect || '/home'
            this.$router.push(redirect)
          } catch (error) {
            console.error('登录失败', error)
          } finally {
            this.loading = false
          }
        }
      })
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 100px);
}

.login-card {
  width: 400px;
}

.login-card h2 {
  text-align: center;
  margin: 0;
}

.register-link {
  text-align: center;
  margin-top: 15px;
}

.register-link a {
  color: #409EFF;
}

.demo-accounts {
  margin-top: 20px;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.demo-accounts p {
  margin: 8px 0;
  font-size: 13px;
  color: #666;
}
</style>
