import { Resolver, Query, Mutation, Ctx, Arg, Int } from "type-graphql";
import { ILike } from 'typeorm';

import { Representative } from "../../entity/Representative";

import { CreateRepresentativeInput } from "./CreateRepresentativeInput";
import { RepresentativesFilterInput } from "./RepresentativesFilterInput";
import { DeleteRepresentativeInput } from "./DeleteRepresentativeInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

// import { RepresentativeInput } from "./RepresentativeInput"

@Resolver()
export class RepresentativeResolver {
	@Query(() => [Representative])
	representatives(@Arg("filter", { nullable: true }) filter?: RepresentativesFilterInput) {
		return Representative.find({
            where: filter ? [
                { lastName: ILike("%" + filter.search + "%") },
                { firstName: ILike("%" + filter.search + "%") },
            ] : [],
            order: { lastName: 'ASC', firstName: 'ASC' }
        })
	}

	// @Query(() => Representative, { nullable: true })
	// async representative(@Arg("data") data: RepresentativeInput) {

	// 	// @ts-ignore
	// 	const representative = await Representative.findOne({ id: data.representativeId }, { relations: ["user"] })
	// 	if (!representative) return


	// 	return representative;
	// }

	// @Arg("data") data: CreateRepresentativeInput, 
	@Mutation(() => Representative, { nullable: true })
	async createRepresentative(@Arg("data") data: CreateRepresentativeInput, @Ctx() ctx: MyContext) {

		console.log(ctx.req.session)// TODO: ne devrait pas être nul

		const user = await User.findOne({ id: data.userId || ctx.req.session!.userId })
		if (!user) return

		const representative = await Representative.create({
            firstName: data.firstName,
            lastName: data.lastName,
			user: user,
		}).save();

		console.log(representative)

		// await representative.save();
		return representative;
	}

	@Mutation(() => Int)
	async deleteRepresentative(@Arg("data") data: DeleteRepresentativeInput) {

		const representative2 = await Representative.delete(data.representativeId)

		console.log('delete representative: ', representative2)

		if (representative2.affected !== 1) return 0

		return 1
	}

}
