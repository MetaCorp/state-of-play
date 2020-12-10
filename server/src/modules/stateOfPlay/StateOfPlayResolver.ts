import { Resolver, Query, Mutation, Ctx, Arg, Int, Authorized } from "type-graphql";
import { /*getManager,*/ ILike } from "typeorm";

import { StateOfPlay } from "../../entity/StateOfPlay";

import { CreateStateOfPlayInput } from "./CreateStateOfPlayInput";
import { StateOfPlaysFilterInput } from "./StateOfPlaysFilterInput";
import { DeleteStateOfPlayInput } from "./DeleteStateOfPlayInput";
import { UpdateStateOfPlayInput } from "./UpdateStateOfPlayInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";
import { Property } from "../../entity/Property";

import { StateOfPlayInput } from "./StateOfPlayInput"
import { Owner } from "../../entity/Owner";
import { Representative } from "../../entity/Representative";

@Resolver()
export class StateOfPlayResolver {
	@Authorized()
	@Query(() => [StateOfPlay])
	// @ts-ignore
	async stateOfPlays(@Arg("filter", { nullable: true }) filter?: StateOfPlaysFilterInput, @Ctx() ctx: MyContext) {
		return StateOfPlay.find({// TODO: filter ne marche pas, trouver une autre solution. => QueryBuilder
			where: filter ? [
                // { property: { address: ILike("%" + filter.search + "%") } },
                // { property: { postalCode: ILike("%" + filter.search + "%") } },
                // { property: { city: ILike("%" + filter.search + "%") } },
                { fullAddress: ILike("%" + filter.search + "%") },
            ] : [
				{ user: { id: ctx.userId }}
			],
			relations: ["user", "owner", "representative", "property"]
		})

		// const stateOfPlays = await getManager()
		// 	.createQueryBuilder(StateOfPlay, "stateOfPlay")
		// 	.leftJoinAndSelect('stateOfPlay.user', 'user')
		// 	.leftJoinAndSelect('stateOfPlay.owner', 'owner')
		// 	.leftJoinAndSelect('stateOfPlay.representative', 'representative')
		// 	.leftJoinAndSelect('stateOfPlay.property', 'property')
		// 	.where('stateOfPlay.user.id = :userId', { userId: ctx.userId })
		// 	.andWhere("stateOfPlay.property.address ilike '%' || :address || '%'", { address: filter ? filter.search : "" })
		// 	// .orWhere("stateOfPlay.property.postalCode ilike '%' || :postalCode || '%'", { postalCode: filter ? filter.search : "" })
		// 	// .orWhere("stateOfPlay.property.city ilike '%' || :city || '%'", { city: filter ? filter.search : "" })
		// 	// .take(pagination && pagination.take)
		// 	// .skip(pagination && pagination.skip)
		// 	.getMany();

		// return stateOfPlays
	}

	@Authorized()
	@Query(() => StateOfPlay, { nullable: true })
	async stateOfPlay(@Arg("data") data: StateOfPlayInput) {

		// @ts-ignore
		const stateOfPlay = await StateOfPlay.findOne({ id: data.stateOfPlayId }, { relations: ["user", "owner", "representative", "property"] })
		if (!stateOfPlay) return


		return stateOfPlay;
	}

	@Authorized()
	@Mutation(() => StateOfPlay, { nullable: true })
	async createStateOfPlay(@Arg("data") data: CreateStateOfPlayInput, @Ctx() ctx: MyContext) {

		// @ts-ignore
		const user = await User.findOne({ id: ctx.userId })
		if (!user) return

		// @ts-ignore
		const owner = await Owner.findOne({ id: data.ownerId })
		if (!owner) return
		
		// @ts-ignore
		const representative = await Representative.findOne({ id: data.representativeId })
		if (!representative) return
		
		// @ts-ignore
		const property = await Property.findOne({ id: data.propertyId })
		if (!property) return

		const stateOfPlay = await StateOfPlay.create({
			fullAddress: property.address + ', ' + property.postalCode + ' ' + property.city,
			user: user,
			owner: owner,
			representative: representative,
			property: property
		}).save();

		console.log(stateOfPlay)

		// await stateOfPlay.save();
		return stateOfPlay;
	}
	
	@Authorized()
	@Mutation(() => Int)
	async updateStateOfPlay(@Arg("data") data: UpdateStateOfPlayInput) {

		const stateOfPlay = await StateOfPlay.update(data.stateOfPlayId, {
		})
		console.log('updateOwner: ', stateOfPlay)

		if (stateOfPlay.affected !== 1) return 0

		return 1
	}

	@Authorized()
	@Mutation(() => Int)
	async deleteStateOfPlay(@Arg("data") data: DeleteStateOfPlayInput) {

		const stateOfPlay = await StateOfPlay.delete(data.stateOfPlayId)

		console.log('deleteStateOfPlay: ', stateOfPlay)

		if (stateOfPlay.affected !== 1) return 0

		return 1
	}

}
