import { Resolver, Query, Mutation, Ctx, Arg } from "type-graphql";

import { StateOfPlay } from "../../entity/StateOfPlay";

import { CreateStateOfPlayInput } from "./CreateStateOfPlayInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";
import { Property } from "../../entity/Property";

import { StateOfPlayInput } from "./StateOfPlayInput"

@Resolver()
export class StateOfPlayResolver {
	@Query(() => [StateOfPlay])
	stateOfPlays() {
		return StateOfPlay.find({ relations: ["user"] })
	}

	@Query(() => StateOfPlay, { nullable: true })
	async stateOfPlay(@Arg("data") data: StateOfPlayInput) {

		// @ts-ignore
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

		// @ts-ignore
		const owner = await User.findOne({ id: data.ownerId })
		if (!owner) return
		
		// @ts-ignore
		const representative = await User.findOne({ id: data.representativeId })
		if (!representative) return
		
		// @ts-ignore
		const property = await Property.findOne({ id: data.propertyId })
		if (!property) return

		const stateOfPlay = await StateOfPlay.create({
			user: user,
			owner: owner,
			representative: representative,
			property: property
		}).save();

		console.log(stateOfPlay)

		// await stateOfPlay.save();
		return stateOfPlay;
	}
}
