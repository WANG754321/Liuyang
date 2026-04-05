<template>
  <div class="my-houses">
    <el-card>
      <template #header>
        <div class="card-header">
          <h2>我的房源</h2>
          <el-button type="primary" @click="showAddDialog">添加房源</el-button>
        </div>
      </template>
      <el-table :data="houses" stripe>
        <el-table-column prop="title" label="标题" />
        <el-table-column prop="address" label="地址" />
        <el-table-column prop="price" label="租金">
          <template #default="{ row }">
            ¥{{ row.price }}/月
          </template>
        </el-table-column>
        <el-table-column prop="area" label="面积">
          <template #default="{ row }">
            {{ row.area }}㎡
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态">
          <template #default="{ row }">
            <el-tag :type="row.status === 1 ? 'success' : 'info'">
              {{ row.status === 1 ? '上架' : row.status === 2 ? '已租' : '下架' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button type="primary" size="small" @click="editHouse(row)">编辑</el-button>
            <el-button type="danger" size="small" @click="deleteHouse(row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑房源' : '添加房源'" width="600px">
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" />
        </el-form-item>
        <el-form-item label="租金" prop="price">
          <el-input-number v-model="form.price" :min="0" />
        </el-form-item>
        <el-form-item label="面积" prop="area">
          <el-input-number v-model="form.area" :min="0" />
        </el-form-item>
        <el-form-item label="房间数">
          <el-input-number v-model="form.roomCount" :min="1" />
        </el-form-item>
        <el-form-item label="客厅数">
          <el-input-number v-model="form.hallCount" :min="0" />
        </el-form-item>
        <el-form-item label="楼层">
          <el-input v-model="form.floor" />
        </el-form-item>
        <el-form-item label="朝向">
          <el-input v-model="form.orientation" />
        </el-form-item>
        <el-form-item label="装修">
          <el-input v-model="form.decoration" />
        </el-form-item>
        <el-form-item label="配套">
          <el-input v-model="form.facilities" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="form.description" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import request from '../utils/request'

export default {
  name: 'MyHouses',
  data() {
    return {
      houses: [],
      dialogVisible: false,
      isEdit: false,
      form: {
        id: null,
        title: '',
        address: '',
        price: 0,
        area: 0,
        roomCount: 1,
        hallCount: 1,
        floor: '',
        orientation: '',
        decoration: '',
        facilities: '',
        description: ''
      },
      rules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
        address: [{ required: true, message: '请输入地址', trigger: 'blur' }],
        price: [{ required: true, message: '请输入租金', trigger: 'blur' }]
      }
    }
  },
  created() {
    this.loadHouses()
  },
  methods: {
    async loadHouses() {
      const user = JSON.parse(localStorage.getItem('user'))
      const res = await request.get(`/house/landlord/${user.id}`)
      this.houses = res.data
    },
    showAddDialog() {
      this.isEdit = false
      this.form = {
        id: null,
        title: '',
        address: '',
        price: 0,
        area: 0,
        roomCount: 1,
        hallCount: 1,
        floor: '',
        orientation: '',
        decoration: '',
        facilities: '',
        description: ''
      }
      this.dialogVisible = true
    },
    editHouse(house) {
      this.isEdit = true
      this.form = { ...house }
      this.dialogVisible = true
    },
    async deleteHouse(id) {
      await this.$confirm('确定删除该房源吗？')
      await request.delete(`/house/${id}`)
      this.$message.success('删除成功')
      this.loadHouses()
    },
    submitForm() {
      this.$refs.formRef.validate(async (valid) => {
        if (valid) {
          const user = JSON.parse(localStorage.getItem('user'))
          this.form.landlordId = user.id
          if (this.isEdit) {
            await request.put('/house', this.form)
            this.$message.success('更新成功')
          } else {
            await request.post('/house', this.form)
            this.$message.success('添加成功')
          }
          this.dialogVisible = false
          this.loadHouses()
        }
      })
    }
  }
}
</script>

<style scoped>
.my-houses {
  max-width: 1200px;
  margin: 0 auto;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-header h2 {
  margin: 0;
}
</style>
