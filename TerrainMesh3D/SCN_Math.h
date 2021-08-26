//
//  SCN_Math.h
//
//  Created by George Warner on 8/15/21.
//
//  No rights reserved... Use at your own risk... blah, blah, blah.
//

#ifndef SCN_Math_h
#define SCN_Math_h

#if PRAGMA_ONCE
#pragma once
#endif

#ifdef __cplusplus
extern "C" {
#endif

#if PRAGMA_IMPORT
#pragma import on
#endif

#if PRAGMA_STRUCT_ALIGN
#pragma options align=mac68k
#elif PRAGMA_STRUCT_PACKPUSH
#pragma pack(push, 2)
#elif PRAGMA_STRUCT_PACK
#pragma pack(2)
#endif

//-----------------------------------------------------
//typedef's, struct's, enum's, etc.
//-----------------------------------------------------

#ifndef DEG2RAD
#define DEG2RAD(d)        ((CGFloat)((d) *  M_PI / 180))
#endif

#ifndef RAD2DEG
#define RAD2DEG(r)        ((CGFloat)((r) *  180 / M_PI))
#endif

#if !defined(MIN)
#define MIN(A, B)    ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a < __b ? __a : __b; })
#endif

#if !defined(MAX)
#define MAX(A, B)    ({ __typeof__(A) __a = (A); __typeof__(B) __b = (B); __a > __b ? __a : __b; })
#endif

#if !defined(PIN)
#define PIN(minValue, maxValue, theValue)    (MAX(minValue, MIN(maxValue, theValue)))
#endif

#if !defined(ABS)
#define ABS(A)    ({ __typeof__(A) __a = (A); __a < 0 ? -__a : __a; })
#endif

#if !defined(SWAP)
#define SWAP(A, B)    ({__typeof__(A) __T = (A); (A) = (B); (B) = __T;})
#endif

#if !defined(XY)
#define XY(V)  (V).x, (V).y
#endif // !defined(XY)

#if !defined(XYZ)
#define XYZ(V)  (V).x, (V).y, (V).z
#endif // !defined(XYZ)

#if !defined(XYZW)
#define XYZW(V)  (V).x, (V).y, (V).z, (V).w
#endif // !defined(XYZW)

#if !defined(RGB)
#define RGB(c)    (c).r, (c).g, (c).b
#endif //if !defined(RGB)

#if !defined(RGBA)
#define RGBA(c) (c).r, (c).g, (c).b, (c).a
#endif //if !defined(RGBA)

#if CGFLOAT_IS_DOUBLE
#define SIN(r) sin(r)
#define COS(r) cos(r)
#define HYPOT(x, y) hypot(x, y)
#define FMOD(x, y) fmod(x, y)
#define SQRT(x) sqrt(x)
#define FLOOR(x) floor(x)
#define CEIL(x) ceil(x)
#define ROUND(x) round(x)
#define LOG(x) log(x)
#define POW(n, e) pow(n, e)
#define FMIN(a, b) fmin(a, b)
#define FMAX(a, b) fmax(a, b)
#else
#define SIN(r) sinf(r)
#define COS(r) cosf(r)
#define HYPOT(x, y) hypotf(x, y)
#define FMOD(x, y) fmodf(x, y)
#define SQRT(x) sqrtf(x)
#define FLOOR(x) floorf(x)
#define CEIL(x) ceilf(x)
#define ROUND(x) roundf(x)
#define LOG(x) logf(x)
#define POW(n, e) powf(n, e)
#define FMIN(a, b) fminf(a, b)
#define FMAX(a, b) fmaxf(a, b)
#endif

#define FPIN(minValue, maxValue, theValue)    (FMAX(minValue, FMIN(maxValue, theValue)))

typedef struct SCN_Plane3D_Struct {
    union {
        CGFloat f[6];
        struct {
            SCNVector3    o;
            SCNVector3    n;
        };
    };
}SCN_Plane3D_Rec, *SCN_Plane3D_Ptr;

//----------------------------------------------------
//external (exported) global consts
//----------------------------------------------------

//----------------------------------------------------
//static inlined functions
//----------------------------------------------------
#pragma mark - "* CGFloat"

static inline CGFloat CGFloatSign(CGFloat n) {
    return (n > 0) - (n < 0);
}

static inline CGFloat CGFloatRandom(CGFloat inCGFloatMin, CGFloat inCGFloatMax)
{
    //CGFloat range = (b - a < 0) ? (b - a - 1) : (b - a + 1);
    CGFloat range = inCGFloatMax - inCGFloatMin;
    range += CGFloatSign(range);
    CGFloat value = (CGFloat)(range * ((CGFloat) arc4random() / (CGFloat) RAND_MAX));
    return (value == range) ? inCGFloatMin : (inCGFloatMin + value);
}

static inline CGFloat CGFloatLERP(CGFloat inCGFloatA, CGFloat inCGFloatB, CGFloat inFraction)
{
    return (1 - inFraction) * inCGFloatA + inCGFloatA * inCGFloatB;
}

static inline CGFloat CGFloatSLERP(CGFloat inCGFloatA, CGFloat inCGFloatB, CGFloat inFraction)
{
    return CGFloatLERP(inCGFloatA, inCGFloatB, (1 - COS(FMOD(inFraction, 1) * M_PI)) / 2);
}

#pragma mark - "* CGPoint"

static inline CGPoint CGPointRandom(CGPoint inCGPointA, CGPoint inCGPointB) {
    return CGPointMake(CGFloatRandom(inCGPointA.x, inCGPointB.x), CGFloatRandom(inCGPointA.y, inCGPointB.y));
}

static inline CGPoint CGPointAdd(CGPoint inCGPointA, CGPoint inCGPointB) {
    return CGPointMake(inCGPointA.x + inCGPointB.x, inCGPointA.y + inCGPointB.y);
}

static inline CGPoint CGPointSubtract(CGPoint inCGPointA, CGPoint inCGPointB) {
    return CGPointMake(inCGPointA.x - inCGPointB.x, inCGPointA.y - inCGPointB.y);
}

static inline CGPoint CGPointScale(CGPoint inCGPointA, CGFloat inScalar) {
    return CGPointMake(inCGPointA.x * inScalar, inCGPointA.y * inScalar);
}

static inline CGPoint CGPointMultiply(CGPoint inCGPointA, CGFloat inScalar) {
    return CGPointScale(inCGPointA, inScalar);
}

static inline CGPoint CGPointDivide(CGPoint inCGPointA, CGFloat inScalar) {
    return CGPointScale(inCGPointA, 1 / inScalar);
}

static inline CGFloat CGPointDistance(CGPoint inCGPointA, CGPoint inCGPointB) {
    CGPoint diff = CGPointSubtract(inCGPointA, inCGPointB);
    return HYPOT(diff.x, diff.y);
}

static inline CGPoint CGPointLerp(CGPoint inCGPointA, CGPoint inCGPointB, CGFloat inFraction) {
    return CGPointMake(CGFloatLERP(inCGPointA.x, inCGPointB.x, inFraction), CGFloatLERP(inCGPointA.y, inCGPointB.y, inFraction));
}

/**
 * get (signed) distance p3 is from line segment defined by p1 and p2
 *
 * @param linePointA the first point on the line segment
 * @param linePointB the second point on the line segment
 * @param thePoint the point whose distance from the line segment you wish to calculate
 * @return the distance (note: plus/minus determines the (left/right) side of the line)
 */
static inline CGFloat CGPointDistanceToLine(CGPoint linePointA,
                                            CGPoint linePointB,
                                            CGPoint thePoint) {
    double a = linePointA.y - linePointB.y;
    double b = linePointB.x - linePointA.x;
    double c = (linePointA.x * linePointB.y) - (linePointB.x * linePointA.y);

    return (a * thePoint.x + b * thePoint.y + c) / HYPOT(a, b);
}

#pragma mark - "* SCNVector3"

static inline SCNVector3 SCNVector3Add(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    SCNVector3 result;
    result.x = inVectorA.x + inVectorB.x;
    result.y = inVectorA.y + inVectorB.y;
    result.z = inVectorA.z + inVectorB.z;
    return result;
}

static inline SCNVector3 SCNVector3Sub(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    SCNVector3 result;
    result.x = inVectorA.x - inVectorB.x;
    result.y = inVectorA.y - inVectorB.y;
    result.z = inVectorA.z - inVectorB.z;
    return result;
}

static inline SCNVector3 SCNVector3Mul(const SCNVector3 inVector, CGFloat inScalar)
{
    SCNVector3 result;
    result.x = inVector.x * inScalar;
    result.y = inVector.y * inScalar;
    result.z = inVector.z * inScalar;
    return result;
}

static inline SCNVector3 SCNVector3Div(const SCNVector3 inVector, CGFloat inScalar)
{
    return SCNVector3Mul(inVector, 1 / inScalar);
}

static inline SCNVector3 SCNVector3Cross(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    SCNVector3 result;
    result.x = inVectorA.y * inVectorB.z - inVectorA.z * inVectorB.y;
    result.y = inVectorA.z * inVectorB.x - inVectorA.x * inVectorB.z;
    result.z = inVectorA.x * inVectorB.y - inVectorA.y * inVectorB.x;
    return result;
}

static inline CGFloat SCNVector3Dot(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    return (inVectorA.x * inVectorB.x + inVectorA.y * inVectorB.y + inVectorA.z * inVectorB.z);
}

static inline SCNVector3 SCNVector3Lerp(const SCNVector3 inVectorA, const SCNVector3 inVectorB, CGFloat inFraction)
{
    CGFloat ratio = fmodf(inFraction, 1);
    return SCNVector3Add(SCNVector3Mul(inVectorA, 1 - ratio), SCNVector3Mul(inVectorB, ratio));
}

static inline CGFloat SCNVector3LenSqr(const SCNVector3 inVector)
{
    return SCNVector3Dot(inVector, inVector);
}

#define SCNVector3Len SCNVector3Length
static inline CGFloat SCNVector3Length(const SCNVector3 inVector)
{
    return SQRT(SCNVector3LenSqr(inVector));
}

#define SCNVector3Dis2 SCNVector3DisSqr
static inline CGFloat SCNVector3DisSqr(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    return SCNVector3LenSqr(SCNVector3Sub(inVectorA, inVectorB));
}

#define SCNVector3Dis SCNVector3Distance
static inline CGFloat SCNVector3Distance(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    return SCNVector3Length(SCNVector3Sub(inVectorA, inVectorB));
}

static inline SCNVector3 SCNVector3Mid(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    return SCNVector3Mul(SCNVector3Add(inVectorA, inVectorB), 0.5f);
}

static inline SCNVector3 SCNVector3Norm(const SCNVector3 inVector)
{
    CGFloat length = SCNVector3Length(inVector);
    if (length < 1.0e-8f)
        return inVector;
    else
        return SCNVector3Mul(inVector, 1 / length);
}

static inline SCNVector3 SCNVector3NormCross(const SCNVector3 inVectorA, const SCNVector3 inVectorB)
{
    return SCNVector3Norm(SCNVector3Cross(inVectorA, inVectorB));
}

#pragma mark - "* Vector4F"

#pragma mark - "* Plane3D"

static inline SCN_Plane3D_Rec SCN_SetPlane3D(const SCNVector3 inVectorA, const SCNVector3 inVectorB, const SCNVector3 inVectorC)
{
    SCN_Plane3D_Rec plane;
    plane.o = inVectorA;
    plane.n = SCNVector3NormCross(SCNVector3Sub(inVectorB, inVectorA), SCNVector3Sub(inVectorC, inVectorA));
    return plane;
}

static inline CGFloat SCN_DistanceToPlane3D(const SCN_Plane3D_Rec inPlane, const SCNVector3 inVector)
{
    return SCNVector3Dot(SCNVector3Sub(inVector, inPlane.o), inPlane.n);
}

#if PRAGMA_STRUCT_ALIGN
#pragma options align=reset
#elif PRAGMA_STRUCT_PACKPUSH
#pragma pack(pop)
#elif PRAGMA_STRUCT_PACK
#pragma pack()
#endif

#ifdef PRAGMA_IMPORT_OFF
#pragma import off
#elif PRAGMA_IMPORT
#pragma import reset
#endif

#ifdef __cplusplus
}
#endif

#endif /* SCN_Math_h */
