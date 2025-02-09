import { JWTPayload } from '.'

export type JwtPayloadWithRt = JWTPayload & { refreshToken: string }
