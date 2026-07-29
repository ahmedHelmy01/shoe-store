// ─────────────────────────────────────────────────────────────────────────────
// NiceOne-Inspired Dynamic Distributed Offers System
//
// Offers are partitioned into 4 distinct widgets across the Home Screen:
//   1. OfferSlot1HeroWidget   -> after "أقسام الصيدلية" (Index 0 - with Timer)
//   2. OfferSlot2DualWidget   -> after "جميع الخدمات"   (Indices 1, 2)
//   3. OfferSlot3ReelWidget   -> after "الكوبونات"      (Indices 3, 4, 5)
//   4. OfferSlot4StripWidget  -> after "الأكثر طلباً"   (Indices 6..N)
//
// Each widget lives in its own file under offer_widgets/
// ─────────────────────────────────────────────────────────────────────────────

export 'offer_widgets/offer_widgets.dart';
