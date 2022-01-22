import express from "express"
const router = express.Router()

import auth from "./auth"
import todo from "./todo"

router.use("/auth", auth)
router.use("/todos", todo)

export default router
