import { Resolver, Query, Mutation, Ctx, Arg } from "type-graphql";

import { StateOfPlay } from "../../entity/StateOfPlay";

import { CreateStateOfPlayInput } from "./CreateStateOfPlayInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

import { StateOfPlayInput } from "./StateOfPlayInput"

@Resolver()
export class StateOfPlayResolver {
	@Query(() => [StateOfPlay])
	stateOfPlays() {
		return StateOfPlay.find({ relations: ["user"] })
	}

	@Query(() => StateOfPlay, { nullable: true })
	async stateOfPlay(@Arg("data") data: StateOfPlayInput) {

		const stateOfPlay = await StateOfPlay.findOne({ id: data.stateOfPlayId }, { relations: ["user"] })
		if (!stateOfPlay) return


		return stateOfPlay;
	}

	// @Arg("data") data: CreateStateOfPlayInput, 
	@Mutation(() => StateOfPlay, { nullable: true })
	async createStateOfPlay(@Arg("data") data: CreateStateOfPlayInput, @Ctx() ctx: MyContext) {

		console.log(ctx.req.session)// TODO: ne devrait pas être nul

		const user = await User.findOne({ id: data.userId || ctx.req.session!.userId })
		if (!user) return

		
		const stateOfPlay = await StateOfPlay.create({
			user: user
		}).save();

		console.log(stateOfPlay)

		// await stateOfPlay.save();
		return stateOfPlay;
	}
}
