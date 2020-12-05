import { Entity, PrimaryGeneratedColumn, Column, BaseEntity, OneToMany } from "typeorm";
import { ObjectType, Field, ID, Root } from "type-graphql";

import { Property } from "./Property";
import { StateOfPlay } from "./StateOfPlay";

@ObjectType()
@Entity()
export class User extends BaseEntity {
  @Field(() => ID)
  @PrimaryGeneratedColumn()
  id: number;

  @Field()
  @Column()
  firstName: string;

  @Field()
  @Column()
  lastName: string;

  @Field()
  @Column("text", { unique: true })
  email: string;

  @Field({ complexity: 3 })
  name(@Root() parent: User): string {
    return `${parent.firstName} ${parent.lastName}`;
  }

  @Column()
  password: string;

  @Column("bool", { default: false })
  confirmed: boolean;
  
  @Field(() => [Property])
  @OneToMany(() => Property, property => property.user)
  properties: Property[];
  
  @Field(() => [StateOfPlay])
  @OneToMany(() => StateOfPlay, stateOfPlay => stateOfPlay.user)
  stateOfPlays: StateOfPlay[];
}
