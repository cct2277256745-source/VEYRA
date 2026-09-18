import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    self.titleVisibility = .hidden
    self.titlebarAppearsTransparent = true
    self.styleMask.insert(.fullSizeContentView)
    self.isOpaque = false

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()

    // 视觉验收工具：通过 VEYRA_WINDOW=宽x高 环境变量设定窗口尺寸
    // （仅显式传入时生效，正常启动不受影响）。
    // awakeFromNib 与启动后 1.5s 各应用一次，防止被后续恢复覆盖。
    let spec = ProcessInfo.processInfo.environment["VEYRA_WINDOW"]
    FileHandle.standardError.write(
      "VEYRA_PROBE awakeFromNib env=[\(spec ?? "nil")] frame=\(windowFrame)\n"
        .data(using: .utf8)!)
    applyVeyraWindowSize(from: spec)

    if spec != nil {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
        guard let self = self else { return }
        self.applyVeyraWindowSize(from: spec)
      }
    }
  }

  private func applyVeyraWindowSize(from spec: String?) {
    guard let spec = spec else { return }
    let parts = spec.split(separator: "x").compactMap { Double($0) }
    guard parts.count == 2, let width = parts.first, let height = parts.last
    else { return }
    self.setContentSize(NSSize(width: width, height: height))
    self.center()
    FileHandle.standardError.write(
      "VEYRA_PROBE applied \(width)x\(height) frame=\(self.frame)\n"
        .data(using: .utf8)!)
  }
}
