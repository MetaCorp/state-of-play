import { Resolver, Query, Mutation, Ctx, Arg } from "type-graphql";
import { ILike } from "typeorm";

import { Owner } from "../../entity/Owner";

import { CreateOwnerInput } from "./CreateOwnerInput";
import { OwnersFilterInput } from "./OwnersFilterInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

// import { OwnerInput } from "./OwnerInput"

@Resolver()
export class OwnerResolver {
	@Query(() => [Owner])
	owners(@Arg("filter") filter: OwnersFilterInput) {
		return Owner.find({
            where: [
                { lastName: ILike("%" + filter.search + "%") },
                { firstName: ILike("%" + filter.search + "%") },
            ],
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
}
