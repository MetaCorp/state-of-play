import { Field, InputType } from "type-graphql";
// @ts-ignore
import { GraphQLUpload, FileUpload } from "graphql-upload";

import { CreateOwnerInput } from "../owner/CreateOwnerInput";
import { CreatePropertyInput } from "../property/CreatePropertyInput";
import { CreateRepresentativeInput } from "../representative/CreateRepresentativeInput";
import { CreateTenantInput } from "../tenant/CreateTenantInput";

@InputType()
class CreateStateOfPlayDecorationInput {
  @Field()
  type: String
  
  @Field()
  nature: String
  
  @Field()
  state: String
  
  @Field()
  comments: String

  @Field(() => [String])
  images: [String]

  @Field(() => [GraphQLUpload])
  newImages: [FileUpload]
}


@InputType()
class CreateStateOfPlayElectricityInput {
  @Field()
  type: String
  
  @Field()
  quantity: Number
  
  @Field()
  state: String
  
  @Field()
  comments: String
}

@InputType()
class CreateStateOfPlayEquipmentInput {
  @Field()
  type: String
  
  @Field()
  quantity: Number

  @Field()
  brandOrObject: String
  
  @Field()
  state: String
  
  @Field()
  comments: String
}

@InputType()
class CreateStateOfPlayMeterInput {
  @Field()
  type: String
  
  @Field()
  location: String

  @Field()
  index: Number
}

@InputType()
class CreateStateOfPlayKeyInput {
  @Field()
  type: String

  @Field()
  comments: String

  @Field()
  count: Number
}


@InputType()
class CreateStateOfPlayRoomInput {
  @Field()
  name: String

  @Field(() => [CreateStateOfPlayDecorationInput])
  decorations: [CreateStateOfPlayDecorationInput]

  @Field(() => [CreateStateOfPlayElectricityInput])
  electricities: [CreateStateOfPlayElectricityInput]

  @Field(() => [CreateStateOfPlayEquipmentInput])
  equipments: [CreateStateOfPlayEquipmentInput]
}

@InputType()
class CreateStateOfPlayInsuranceInput {
  @Field()
  company: String

  @Field()
  number: String
}

@InputType()
export class CreateStateOfPlayInput {// TODO
  @Field()
  out: boolean;

  @Field(() => CreatePropertyInput)
  property: CreatePropertyInput
  
  @Field(() => CreateOwnerInput)
  owner: CreateOwnerInput
  
  @Field(() => CreateRepresentativeInput)
  representative: CreateRepresentativeInput

  @Field(() => [CreateTenantInput])
  tenants: [CreateTenantInput]

  @Field(() => [CreateStateOfPlayRoomInput])
  rooms: [CreateStateOfPlayRoomInput]
  
  @Field(() => [CreateStateOfPlayMeterInput])
  meters: [CreateStateOfPlayMeterInput]

  @Field(() => [CreateStateOfPlayKeyInput])
  keys: [CreateStateOfPlayKeyInput]

  @Field(() => CreateStateOfPlayInsuranceInput)
  insurance: CreateStateOfPlayInsuranceInput

  @Field()
  comments: String
  
  @Field()
  reserve: String
}
