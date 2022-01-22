import User from "../models/User"
import { verifyToken } from "../utils/token"

const auth = async (req, res, next) => {
	const { authorization } = req.headers

	if (!authorization) {
		return res.status(401).json({
			error: "token is required",
		})
	}

	const [bearer, token] = authorization.split(" ")

	try {
		const result = verifyToken(token)
		const user = await User.findByPk(result.sub)
        req.user = user.toJSON()
		next()
	} catch (error) {
		res.status(401).json({
			error: error.message,
		})
	}
}

export default auth
