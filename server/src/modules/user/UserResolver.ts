import { Query, Resolver, Ctx, Arg, Mutation, Int  } from "type-graphql";
import { MyContext } from "../../types/MyContext";

import { UserInput } from "./UserInput";
import { UpdateUserInput } from "./UpdateUserInput";
import { DeleteUserInput } from "./DeleteUserInput";

import { User } from "../../entity/User";

@Resolver()
export class UserResolver {
  @Query(() => [User])
  async users() {
    return User.find({ relations: ["properties", "stateOfPlays", "stateOfPlays.property"] });
  }

  @Query(() => User, { nullable: true })
	async user(@Arg("data") data: UserInput, @Ctx() ctx: MyContext,) {

		// console.log(ctx.req.session)// TODO: ne devrait pas être nul

		const user = await User.findOne({ id: data.userId || ctx.req.session!.userId }, { relations: ["properties", "stateOfPlays", "stateOfPlays.property"] })
		if (!user) return

		// console.log('properties: ', user.properties)

		return user;
	}

	
	@Mutation(() => Int)
	async updateUser(@Arg("data") data: UpdateUserInput) {

		const user = await User.update(data.userId, {
			firstName: data.user.firstName,
			lastName: data.user.lastName
		})
		console.log('updateOwner: ', user)

		if (user.affected !== 1) return 0

		return 1
	}

	@Mutation(() => Int)
	async deleteUser(@Arg("data") data: DeleteUserInput) {

		const user = await User.delete(data.userId)

		console.log('deleteUser: ', user)

		if (user.affected !== 1) return 0

		return 1
	}
}
