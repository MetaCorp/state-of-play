import { Resolver, Query, Mutation, Ctx, Arg, Int } from "type-graphql";
import { ILike } from "typeorm";

import { Owner } from "../../entity/Owner";

import { CreateOwnerInput } from "./CreateOwnerInput";
import { OwnersFilterInput } from "./OwnersFilterInput";
import { DeleteOwnerInput } from "./DeleteOwnerInput";
import { UpdateOwnerInput } from "./UpdateOwnerInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

// import { OwnerInput } from "./OwnerInput"

@Resolver()
export class OwnerResolver {
	@Query(() => [Owner])
	owners(@Arg("filter", { nullable: true }) filter?: OwnersFilterInput) {
		return Owner.find({
            where: filter ? [
                { lastName: ILike("%" + filter.search + "%") },
                { firstName: ILike("%" + filter.search + "%") },
            ] : [],
            order: { lastName: 'ASC', firstName: 'ASC' }
        })
	}

	// @Query(() => Owner, { nullable: true })
	// async owner(@Arg("data") data: OwnerInput) {

	// 	// @ts-ignore
	// 	const owner = await Owner.findOne({ id: data.ownerId }, { relations: ["user"] })
	// 	if (!owner) return


	// 	return owner;
	// }

	// @Arg("data") data: CreateOwnerInput, 
	@Mutation(() => Owner, { nullable: true })
	async createOwner(@Arg("data") data: CreateOwnerInput, @Ctx() ctx: MyContext) {

		console.log(ctx.req.session)// TODO: ne devrait pas être nul

		const user = await User.findOne({ id: data.userId || ctx.req.session!.userId })
		if (!user) return

		const owner = await Owner.create({
            firstName: data.firstName,
            lastName: data.lastName,
			user: user,
		}).save();

		console.log(owner)

		// await owner.save();
		return owner;
	}
	
	@Mutation(() => Int)
	async updateOwner(@Arg("data") data: UpdateOwnerInput) {

		const owner = await Owner.update(data.ownerId, {
            firstName: data.owner.firstName,
            lastName: data.owner.lastName,
		})
		console.log('updateOwner: ', owner)

		if (owner.affected !== 1) return 0

		return 1
	}
	
	@Mutation(() => Int)
	async deleteOwner(@Arg("data") data: DeleteOwnerInput) {

		const owner2 = await Owner.delete(data.ownerId)

		console.log('delete owner: ', owner2)

		if (owner2.affected !== 1) return 0

		return 1
	}

}
