import { Resolver, Query, Mutation, Ctx, Arg } from "type-graphql";

import { Representative } from "../../entity/Representative";

import { CreateRepresentativeInput } from "./CreateRepresentativeInput";

import { MyContext } from "../../types/MyContext";
import { User } from "../../entity/User";

// import { RepresentativeInput } from "./RepresentativeInput"

@Resolver()
export class RepresentativeResolver {
	@Query(() => [Representative])
	representatives() {
		return Representative.find()
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
}
