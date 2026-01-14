module PagesHelper
  def status_style(status)
    case status
    when "up"
      { base: "emerald-500", ping_bg: "bg-emerald-500", bg: "bg-emerald-950/20", text: "text-emerald-700", border: "border border-emerald-900/50" }
    when "down"
      { base: "rose-400", ping_bg: "bg-rose-400", bg: "bg-rose-950/20", text: "text-rose-700", border: "border border-rose-900/50" }
    when "maintenance"
      { base: "yellow-400", ping_bg: "bg-yellow-400", bg: "bg-yellow-950/20", text: "text-yellow-700", border: "border-yellow-900/50" }
    else
      { base: "orange-400", ping_bg: "bg-orange-400", bg: "bg-slate-900", text: "text-slate-800", border: "border border-slate-800" }
    end
  end
end
