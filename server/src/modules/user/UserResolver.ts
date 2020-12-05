import { Query, Resolver, Ctx, Arg  } from "type-graphql";
import { MyContext } from "../../types/MyContext";

import { UserInput } from "./UserInput";

import { User } from "../../entity/User";

@Resolver()
export class UserResolver {
  @Query(() => [User])
  async users() {
    return User.find({ relations: ["properties"] });
  }

  @Query(() => User, { nullable: true })
	async user(@Arg("data") data: UserInput, @Ctx() ctx: MyContext,) {

		// console.log(ctx.req.session)// TODO: ne devrait pas être nul

		const user = await User.findOne({ id: data.userId || ctx.req.session!.userId }, { relations: ["properties"] })
		if (!user) return

		// console.log('properties: ', user.properties)

		return user;
	}
}
